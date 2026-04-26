from flask import Blueprint, request, jsonify
from config import get_db

auth_bp = Blueprint('auth', __name__)

# Hardcoded users - no password column needed in DB
USERS = {
    "amit.sharma@aurabank.com": {"password": "admin123", "role": "ADMIN"},
    "priya.nair@aurabank.com": {"password": "analyst123", "role": "ANALYST"},
    "rajesh.iyer@aurabank.com": {"password": "manager123", "role": "MANAGER"},
}

@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.json
    email = data.get('email')
    password = data.get('password')

    if email not in USERS or USERS[email]['password'] != password:
        return jsonify({"success": False, "message": "Invalid credentials"}), 401

    # Get real user data from DB
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute(
        "SELECT * FROM loan_officer WHERE email=%s",
        (email,)
    )
    user = cursor.fetchone()
    cursor.close()
    db.close()

    if user:
        return jsonify({
            "success": True,
            "user": {
                "id": user['officer_id'],
                "name": f"{user['first_name']} {user['last_name']}",
                "email": user['email'],
                "role": USERS[email]['role'],
                "designation": user['designation']
            }
        })
    return jsonify({"success": False, "message": "User not found"}), 404