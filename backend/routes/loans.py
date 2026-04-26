from flask import Blueprint, request, jsonify
from config import get_db

loans_bp = Blueprint('loans', __name__)

@loans_bp.route('/', methods=['GET'])
def get_all_loans():
    db = get_db()
    cursor = db.cursor(dictionary=True, buffered=True)
    cursor.execute("""
        SELECT 
            la.application_id,
            la.application_number,
            c.company_name,
            la.loan_type,
            la.requested_amount,
            la.status,
            la.application_date,
            CONCAT(lo.first_name,' ',lo.last_name) AS officer_name
        FROM loan_application la
        JOIN company c ON la.company_id = c.company_id
        JOIN loan_officer lo ON la.officer_id = lo.officer_id
        ORDER BY la.created_at DESC
    """)
    loans = cursor.fetchall()
    cursor.close()
    db.close()
    return jsonify({"success": True, "data": loans})

@loans_bp.route('/<int:id>', methods=['GET'])
def get_loan(id):
    db = get_db()
    cursor = db.cursor(dictionary=True, buffered=True)
    cursor.execute("""
        SELECT 
            la.*,
            c.company_name,
            c.industry,
            c.annual_revenue,
            c.city,
            c.country,
            CONCAT(lo.first_name,' ',lo.last_name) AS officer_name,
            lo.designation
        FROM loan_application la
        JOIN company c ON la.company_id = c.company_id
        JOIN loan_officer lo ON la.officer_id = lo.officer_id
        WHERE la.application_id = %s
    """, (id,))
    loan = cursor.fetchone()
    cursor.close()

    if not loan:
        db.close()
        return jsonify({"success": False, "message": "Not found"}), 404

    # Get risk assessment separately
    cursor2 = db.cursor(dictionary=True, buffered=True)
    cursor2.execute("""
        SELECT risk_score, risk_category, model_version
        FROM risk_assessment
        WHERE application_id = %s
        ORDER BY assessment_date DESC
        LIMIT 1
    """, (id,))
    risk = cursor2.fetchone()
    cursor2.close()

    # Get loan outcome separately
    cursor3 = db.cursor(dictionary=True, buffered=True)
    cursor3.execute("""
        SELECT decision, remarks
        FROM loan_outcome
        WHERE application_id = %s
        LIMIT 1
    """, (id,))
    outcome = cursor3.fetchone()
    cursor3.close()
    db.close()

    if risk:
        loan['risk_score'] = risk['risk_score']
        loan['risk_category'] = risk['risk_category']
        loan['model_version'] = risk['model_version']
    else:
        loan['risk_score'] = None
        loan['risk_category'] = None
        loan['model_version'] = None

    if outcome:
        loan['decision'] = outcome['decision']
        loan['remarks'] = outcome['remarks']
    else:
        loan['decision'] = None
        loan['remarks'] = None

    return jsonify({"success": True, "data": loan})

@loans_bp.route('/', methods=['POST'])
def create_loan():
    data = request.json
    db = get_db()
    cursor = db.cursor(buffered=True)
    cursor.execute("""
        INSERT INTO loan_application 
        (application_number, company_id, officer_id, loan_type, requested_amount, purpose, application_date)
        VALUES (%s, %s, %s, %s, %s, %s, CURDATE())
    """, (
        data['application_number'],
        data['company_id'],
        data['officer_id'],
        data['loan_type'],
        data['requested_amount'],
        data['purpose']
    ))
    new_id = cursor.lastrowid
    cursor.execute("""
        INSERT INTO audit_log (application_id, action, performed_by, new_value)
        VALUES (%s, 'APPLICATION_CREATED', %s, 'SUBMITTED')
    """, (new_id, data.get('officer_email', 'SYSTEM')))
    db.commit()
    cursor.close()
    db.close()
    return jsonify({"success": True, "application_id": new_id}), 201

@loans_bp.route('/<int:id>/status', methods=['PUT'])
def update_status(id):
    data = request.json
    new_status = data.get('status')
    db = get_db()
    cursor = db.cursor(buffered=True)
    cursor.execute(
        "UPDATE loan_application SET status=%s WHERE application_id=%s",
        (new_status, id)
    )
    cursor.execute("""
        INSERT INTO audit_log (application_id, action, performed_by, new_value)
        VALUES (%s, 'STATUS_CHANGE', %s, %s)
    """, (id, data.get('performed_by', 'SYSTEM'), new_status))
    db.commit()
    cursor.close()
    db.close()
    return jsonify({"success": True, "message": "Status updated"})