from flask import Flask
from flask_cors import CORS
from routes.auth import auth_bp
from routes.loans import loans_bp
from routes.risk import risk_bp
from routes.audit import audit_bp
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

CORS(app, resources={r"/api/*": {"origins": "*"}}, supports_credentials=False)

app.register_blueprint(auth_bp, url_prefix='/api/auth')
app.register_blueprint(loans_bp, url_prefix='/api/loans')
app.register_blueprint(risk_bp, url_prefix='/api/risk')
app.register_blueprint(audit_bp, url_prefix='/api/audit')

@app.route('/')
def home():
    return {"message": "AURA API is running", "version": "1.0"}

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)