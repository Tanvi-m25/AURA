"use client";
import { useEffect, useState, Suspense } from "react";
import axios from "axios";
import Sidebar from "@/components/Navbar";
import { useRouter, useSearchParams } from "next/navigation";
import { API_BASE } from "@/lib/api";

function RiskContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const id = searchParams.get("id");
  const [user, setUser] = useState<any>(null);
  const [loan, setLoan] = useState<any>(null);
  const [result, setResult] = useState<any>(null);
  const [explanation, setExplanation] = useState("");
  const [analyzing, setAnalyzing] = useState(false);
  const [explaining, setExplaining] = useState(false);
  const [updatingStatus, setUpdatingStatus] = useState(false);
  const [message, setMessage] = useState("");
  const [ready, setReady] = useState(false);

  useEffect(() => {
    const stored = localStorage.getItem("aura_user");
    if (!stored) { router.push("/"); return; }
    setUser(JSON.parse(stored));
    setReady(true);
  }, []);

  useEffect(() => {
    if (!ready) return;
    if (!id) { router.push("/loans"); return; }
    axios.get(`${API_BASE}/api/loans/${id}`)
      .then((res) => {
        setLoan(res.data.data);
        if (res.data.data.risk_score) {
          setResult({
            risk_score: res.data.data.risk_score,
            risk_category: res.data.data.risk_category,
          });
        }
      })
      .catch(() => setLoan(null));
  }, [id, ready]);

  const riskColor: any = {
    LOW: { text: "text-emerald-400", gauge: "#10b981" },
    MEDIUM: { text: "text-amber-400", gauge: "#f59e0b" },
    HIGH: { text: "text-orange-400", gauge: "#f97316" },
    VERY_HIGH: { text: "text-red-400", gauge: "#ef4444" },
    CRITICAL: { text: "text-red-300", gauge: "#dc2626" },
  };

  const handleAnalyze = async () => {
    setAnalyzing(true);
    setMessage("");
    setExplanation("");
    try {
      const res = await axios.post(`${API_BASE}/api/risk/analyze/${id}`);
      setResult(res.data);
      setLoan((prev: any) => ({ ...prev, status: "RISK_ASSESSMENT" }));
    } catch (e) {
      console.error("analyze error:", e);
    }
    setAnalyzing(false);
  };

  const handleExplain = async () => {
    setExplaining(true);
    try {
      const res = await axios.get(`${API_BASE}/api/risk/explain/${id}`);
      console.log("explain response:", res.data);
      if (res.data && res.data.explanation) {
        setExplanation(res.data.explanation);
      } else {
        setExplanation("No explanation returned from server.");
      }
    } catch (e: any) {
      console.error("explain error full:", e);
      console.error("explain error response:", e?.response);
      const serverMsg = e?.response?.data?.message;
      if (serverMsg) {
        setExplanation(`⚠️ ${serverMsg}`);
      } else {
        setExplanation(`⚠️ Network error: ${e.message}`);
      }
    }
    setExplaining(false);
  };

  const handleDecision = async (decision: string) => {
    setUpdatingStatus(true);
    try {
      await axios.put(`${API_BASE}/api/loans/${id}/status`, {
        status: decision,
        performed_by: user?.email,
      });
      setLoan((prev: any) => ({ ...prev, status: decision }));
      setMessage(decision === "APPROVED" ? "✅ Loan approved successfully!" : "❌ Loan rejected.");
    } catch (e) {
      console.error(e);
    }
    setUpdatingStatus(false);
  };

  const RiskGauge = ({ score, category }: { score: number; category: string }) => {
    const color = riskColor[category]?.gauge || "#6366f1";
    const circumference = Math.PI * 80;
    const progress = (score / 100) * circumference;
    return (
      <div className="flex flex-col items-center">
        <svg width="200" height="120" viewBox="0 0 200 120">
          <path d="M 20 100 A 80 80 0 0 1 180 100"
            fill="none" stroke="#1e293b" strokeWidth="16" strokeLinecap="round" />
          <path d="M 20 100 A 80 80 0 0 1 180 100"
            fill="none" stroke={color} strokeWidth="16" strokeLinecap="round"
            strokeDasharray={`${progress} ${circumference}`}
            style={{ transition: "stroke-dasharray 1s ease" }} />
          <text x="100" y="90" textAnchor="middle" fill="white" fontSize="28" fontWeight="bold">{score}</text>
          <text x="100" y="108" textAnchor="middle" fill="#94a3b8" fontSize="11">out of 100</text>
          <text x="18" y="118" fill="#94a3b8" fontSize="9">LOW</text>
          <text x="170" y="118" fill="#94a3b8" fontSize="9">HIGH</text>
        </svg>
        <span className={`text-xl font-bold mt-1 ${riskColor[category]?.text || "text-white"}`}>
          {category} RISK
        </span>
      </div>
    );
  };

  const statusColor: any = {
    APPROVED: "bg-emerald-500/20 text-emerald-400",
    DISBURSED: "bg-blue-500/20 text-blue-400",
    REJECTED: "bg-red-500/20 text-red-400",
    SUBMITTED: "bg-slate-500/20 text-slate-400",
    UNDER_REVIEW: "bg-amber-500/20 text-amber-400",
    RISK_ASSESSMENT: "bg-purple-500/20 text-purple-400",
  };

  if (!ready) {
    return (
      <div className="min-h-screen bg-slate-950 flex items-center justify-center">
        <p className="text-slate-500">Loading...</p>
      </div>
    );
  }

  if (!loan) {
    return (
      <div className="flex min-h-screen bg-slate-950">
        <Sidebar user={user} />
        <main className="ml-60 flex-1 flex items-center justify-center">
          <p className="text-slate-500">Loading loan details...</p>
        </main>
      </div>
    );
  }

  return (
    <div className="flex min-h-screen bg-slate-950">
      <Sidebar user={user} />
      <main className="ml-60 flex-1 p-8 overflow-y-auto">
        {/* Header */}
        <div className="mb-6 flex items-center gap-4">
          <button
            onClick={() => router.push("/loans")}
            className="text-slate-400 hover:text-white transition-colors text-sm"
          >
            ← Back
          </button>
          <div>
            <h1 className="text-2xl font-bold text-white">Risk Analysis</h1>
            <p className="text-slate-400 text-sm">AI-powered credit risk assessment</p>
          </div>
        </div>

        <div className="grid grid-cols-3 gap-6">
          {/* Left col */}
          <div className="col-span-2 space-y-6">

            {/* Loan details */}
            <div className="bg-slate-900 border border-slate-800 rounded-2xl p-6">
              <div className="flex items-center justify-between mb-4">
                <h2 className="font-semibold text-white">Loan Details</h2>
                <span className={`px-2.5 py-1 rounded-full text-xs font-medium ${statusColor[loan.status] || statusColor.SUBMITTED}`}>
                  {loan.status}
                </span>
              </div>
              <div className="grid grid-cols-3 gap-3 text-sm">
                {[
                  { label: "Company", value: loan.company_name },
                  { label: "Industry", value: loan.industry },
                  { label: "Credit Rating", value: loan.credit_rating || "N/A" },
                  { label: "Loan Type", value: loan.loan_type },
                  { label: "Requested Amount", value: `₹${(parseFloat(loan.requested_amount) / 100000).toFixed(1)}L` },
                  { label: "Annual Revenue", value: `₹${(parseFloat(loan.annual_revenue || 0) / 10000000).toFixed(1)}Cr` },
                  { label: "Officer", value: loan.officer_name },
                  { label: "Application #", value: loan.application_number },
                  { label: "Date", value: new Date(loan.application_date).toLocaleDateString("en-IN") },
                ].map((item) => (
                  <div key={item.label} className="bg-slate-800/50 rounded-xl p-3">
                    <p className="text-slate-500 text-xs mb-1">{item.label}</p>
                    <p className="text-white font-medium text-sm">{item.value || "—"}</p>
                  </div>
                ))}
              </div>
              {loan.purpose && (
                <div className="mt-3 bg-slate-800/50 rounded-xl p-3">
                  <p className="text-slate-500 text-xs mb-1">Loan Purpose</p>
                  <p className="text-white text-sm">{loan.purpose}</p>
                </div>
              )}
            </div>

            {/* AI Explanation */}
            {explanation && (
              <div className="bg-indigo-500/5 border border-indigo-500/20 rounded-2xl p-6">
                <div className="flex items-center gap-2 mb-3">
                  <span className="text-lg">✨</span>
                  <h2 className="font-semibold text-white">AI Risk Explanation</h2>
                </div>
                <p className="text-slate-300 leading-relaxed text-sm whitespace-pre-wrap">{explanation}</p>
              </div>
            )}

            {/* Decision */}
            {result && !["APPROVED", "REJECTED", "DISBURSED"].includes(loan.status) && (
              <div className="bg-slate-900 border border-slate-800 rounded-2xl p-6">
                <h2 className="font-semibold text-white mb-4">Make Decision</h2>
                {message && (
                  <div className={`mb-4 px-4 py-3 rounded-xl text-sm font-medium border ${
                    message.includes("approved")
                      ? "bg-emerald-500/10 text-emerald-400 border-emerald-500/20"
                      : "bg-red-500/10 text-red-400 border-red-500/20"
                  }`}>
                    {message}
                  </div>
                )}
                <div className="flex gap-3">
                  <button
                    onClick={() => handleDecision("APPROVED")}
                    disabled={updatingStatus}
                    className="flex-1 py-3 bg-emerald-500/20 hover:bg-emerald-500/30 text-emerald-400 border border-emerald-500/30 rounded-xl font-semibold transition-all disabled:opacity-50 text-sm"
                  >
                    ✓ Approve Loan
                  </button>
                  <button
                    onClick={() => handleDecision("REJECTED")}
                    disabled={updatingStatus}
                    className="flex-1 py-3 bg-red-500/20 hover:bg-red-500/30 text-red-400 border border-red-500/30 rounded-xl font-semibold transition-all disabled:opacity-50 text-sm"
                  >
                    ✕ Reject Loan
                  </button>
                </div>
              </div>
            )}

            {["APPROVED", "REJECTED"].includes(loan.status) && (
              <div className={`rounded-2xl p-4 text-sm font-medium border ${
                loan.status === "APPROVED"
                  ? "bg-emerald-500/10 text-emerald-400 border-emerald-500/20"
                  : "bg-red-500/10 text-red-400 border-red-500/20"
              }`}>
                {loan.status === "APPROVED" ? "✅ This loan has been approved" : "❌ This loan has been rejected"}
              </div>
            )}
          </div>

          {/* Right col */}
          <div className="space-y-4">
            <div className="bg-slate-900 border border-slate-800 rounded-2xl p-6 text-center">
              <h2 className="font-semibold text-white mb-4">Risk Score</h2>
              {result ? (
                <RiskGauge score={result.risk_score} category={result.risk_category} />
              ) : (
                <div className="py-8">
                  <div className="w-16 h-16 rounded-full border-4 border-slate-700 flex items-center justify-center mx-auto mb-3">
                    <span className="text-2xl">🔍</span>
                  </div>
                  <p className="text-slate-500 text-sm">Run analysis to see score</p>
                </div>
              )}
              <div className="mt-6 space-y-2">
                <button
                  onClick={handleAnalyze}
                  disabled={analyzing}
                  className="w-full py-2.5 bg-indigo-600 hover:bg-indigo-500 text-white font-semibold rounded-xl transition-all disabled:opacity-50 text-sm"
                >
                  {analyzing ? "Analyzing..." : "🔍 Run Risk Analysis"}
                </button>
                <button
                  onClick={handleExplain}
                  disabled={explaining || !result}
                  className="w-full py-2.5 bg-slate-800 hover:bg-slate-700 text-slate-300 font-semibold rounded-xl transition-all disabled:opacity-50 text-sm"
                >
                  {explaining ? "Generating..." : "✨ Explain with AI"}
                </button>
              </div>
            </div>

            <div className="bg-slate-900 border border-slate-800 rounded-2xl p-4">
              <p className="text-slate-400 text-xs font-medium mb-3 uppercase tracking-wider">Risk Scale</p>
              {[
                { label: "LOW", range: "0 – 44", color: "bg-emerald-500" },
                { label: "MEDIUM", range: "45 – 64", color: "bg-amber-500" },
                { label: "HIGH", range: "65 – 84", color: "bg-orange-500" },
                { label: "CRITICAL", range: "85 – 100", color: "bg-red-500" },
              ].map((r) => (
                <div key={r.label} className="flex items-center gap-2 mb-2">
                  <div className={`w-2.5 h-2.5 rounded-full ${r.color}`} />
                  <span className="text-xs text-slate-300 font-medium">{r.label}</span>
                  <span className="text-xs text-slate-600 ml-auto">{r.range}</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}

export default function RiskPage() {
  return (
    <Suspense fallback={
      <div className="min-h-screen bg-slate-950 flex items-center justify-center text-slate-400">
        Loading...
      </div>
    }>
      <RiskContent />
    </Suspense>
  );
}