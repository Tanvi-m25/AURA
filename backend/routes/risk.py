from flask import Blueprint, request, jsonify
from config import get_db
import os

risk_bp = Blueprint('risk', __name__)

def calculate_risk_score(data):
    score = 0
    revenue = float(data.get('annual_revenue') or 1)
    loan = float(data.get('requested_amount') or 0)
    ratio = loan / revenue if revenue > 0 else 1
    if ratio < 0.1: score += 20
    elif ratio < 0.3: score += 35
    elif ratio < 0.5: score += 50
    elif ratio < 1.0: score += 65
    else: score += 85
    score = min(score, 100)
    if score >= 85: category = 'CRITICAL'
    elif score >= 65: category = 'HIGH'
    elif score >= 45: category = 'MEDIUM'
    else: category = 'LOW'
    return round(score, 2), category

def rule_based_explanation(data):
    score = float(data['risk_score'])
    category = data['risk_category']
    revenue = float(data['annual_revenue'] or 0)
    loan = float(data['requested_amount'] or 0)
    ratio = (loan / revenue * 100) if revenue > 0 else 0

    if category == 'LOW':
        tone = "presents a strong credit profile with manageable debt obligations"
        rec = "This application is recommended for approval subject to standard documentation review."
    elif category == 'MEDIUM':
        tone = "presents a moderate credit profile with some areas requiring closer attention"
        rec = "Further due diligence is recommended before proceeding with final approval."
    elif category == 'HIGH':
        tone = "presents elevated credit risk that warrants careful scrutiny by the credit committee"
        rec = "Additional collateral or third-party guarantees should be secured before approval."
    else:
        tone = "presents critical risk levels that pose significant concern to the institution"
        rec = "This application is recommended for rejection or escalation to senior credit committee."

    return (
        f"{data['company_name']} operating in the {data['industry']} sector {tone}. "
        f"The requested loan of Rs {loan/100000:.1f}L represents {ratio:.1f}% of annual revenue "
        f"of Rs {revenue/10000000:.1f}Cr, yielding a risk score of {score}/100 "
        f"in the {category} risk category. {rec}"
    )

@risk_bp.route('/analyze/<int:application_id>', methods=['POST'])
def analyze_risk(application_id):
    db = get_db()
    cursor = db.cursor(dictionary=True, buffered=True)
    cursor.execute("""
        SELECT la.requested_amount, la.loan_type, la.purpose,
               c.annual_revenue, c.industry
        FROM loan_application la
        JOIN company c ON la.company_id = c.company_id
        WHERE la.application_id = %s
    """, (application_id,))
    loan = cursor.fetchone()
    cursor.close()

    if not loan:
        db.close()
        return jsonify({"success": False, "message": "Not found"}), 404

    score, category = calculate_risk_score(loan)

    cursor2 = db.cursor(buffered=True)
    try:
        cursor2.execute("""
            INSERT INTO risk_assessment 
            (application_id, risk_score, risk_category, model_version, assessment_date)
            VALUES (%s, %s, %s, 'AURA-v1.0', CURDATE())
        """, (application_id, score, category))
    except Exception:
        cursor2.execute("""
            UPDATE risk_assessment 
            SET risk_score=%s, risk_category=%s, model_version='AURA-v1.0', assessment_date=CURDATE()
            WHERE application_id=%s
        """, (score, category, application_id))

    cursor2.execute(
        "UPDATE loan_application SET status='RISK_ASSESSMENT' WHERE application_id=%s",
        (application_id,)
    )
    db.commit()
    cursor2.close()
    db.close()

    return jsonify({"success": True, "risk_score": score, "risk_category": category})

@risk_bp.route('/explain/<int:application_id>', methods=['GET'])
def explain_risk(application_id):
    db = get_db()
    cursor = db.cursor(dictionary=True, buffered=True)
    cursor.execute("""
        SELECT la.requested_amount, la.loan_type, la.purpose,
               c.company_name, c.annual_revenue, c.industry,
               ra.risk_score, ra.risk_category
        FROM loan_application la
        JOIN company c ON la.company_id = c.company_id
        JOIN risk_assessment ra ON la.application_id = ra.application_id
        WHERE la.application_id = %s
        ORDER BY ra.assessment_date DESC
        LIMIT 1
    """, (application_id,))
    data = cursor.fetchone()
    cursor.close()
    db.close()

    if not data:
        return jsonify({"success": False, "message": "No risk assessment found. Run analysis first."}), 404

    # Try Gemini first
    explanation = None
    try:
        import requests as req
        url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=AIzaSyAFyP6FsXtoKFQxp9VHe1i2gAkzLjr2AVc"
        body = {
            "contents": [{
                "parts": [{
                    "text": f"""You are a senior credit risk officer at a bank. Write a 3-4 sentence professional risk assessment. No bullet points. No markdown.

Company: {data['company_name']}
Industry: {data['industry']}
Loan Amount: Rs {float(data['requested_amount'])/100000:.1f}L
Annual Revenue: Rs {float(data['annual_revenue'] or 0)/10000000:.1f}Cr
Risk Score: {data['risk_score']}/100
Risk Category: {data['risk_category']}
Purpose: {data['purpose']}"""
                }]
            }]
        }
        response = req.post(url, json=body, timeout=20)
        result = response.json()
        if "candidates" in result:
            explanation = result["candidates"][0]["content"]["parts"][0]["text"].strip()
    except Exception:
        pass

    # Always fall back to rule-based if Gemini fails
    if not explanation:
        explanation = rule_based_explanation(data)

    return jsonify({
        "success": True,
        "explanation": explanation,
        "risk_score": data['risk_score'],
        "risk_category": data['risk_category']
    })