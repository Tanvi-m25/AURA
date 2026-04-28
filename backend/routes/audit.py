from flask import Blueprint, jsonify
from config import get_db

audit_bp = Blueprint('audit', __name__)

@audit_bp.route('/', methods=['GET'])
def get_audit_log():
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute("""
        SELECT al.*, la.application_number
        FROM audit_log al
        LEFT JOIN loan_application la ON al.application_id = la.application_id
        ORDER BY al.created_at DESC
        LIMIT 100
    """)
    logs = cursor.fetchall()
    cursor.close()
    db.close()
    return jsonify({"success": True, "data": logs})