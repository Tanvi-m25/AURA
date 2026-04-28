"use client";
import { useEffect, useState } from "react";
import axios from "axios";
import Sidebar from "@/components/Navbar";
import { useRouter } from "next/navigation";
import { API_BASE } from "@/lib/api";

export default function ApprovalPage() {
  const router = useRouter();
  const [user, setUser] = useState<any>(null);
  const [loans, setLoans] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [updating, setUpdating] = useState<number | null>(null);

  useEffect(() => {
    const stored = localStorage.getItem("aura_user");
    if (!stored) { router.push("/"); return; }
    setUser(JSON.parse(stored));
    fetchLoans();
  }, []);

  const fetchLoans = () => {
    axios.get(`${API_BASE}/api/loans/`).then((res) => {
      const pending = res.data.data.filter((l: any) =>
        ["SUBMITTED", "UNDER_REVIEW", "RISK_ASSESSMENT"].includes(l.status)
      );
      setLoans(pending);
      setLoading(false);
    });
  };

  const updateStatus = async (id: number, status: string) => {
    setUpdating(id);
    try {
      await axios.put(`${API_BASE}/api/loans/${id}/status`, {
        status,
        performed_by: user?.email,
      });
      fetchLoans();
    } catch (e) { console.error(e); }
    setUpdating(null);
  };

  return (
    <div className="flex min-h-screen bg-slate-950">
      <Sidebar user={user} />
      <main className="ml-60 flex-1 p-8">
        <div className="mb-6">
          <h1 className="text-2xl font-bold text-white">Approval Workflow</h1>
          <p className="text-slate-400 text-sm mt-1">{loans.length} applications pending decision</p>
        </div>

        {loading ? (
          <div className="text-slate-500 text-center py-20">Loading...</div>
        ) : loans.length === 0 ? (
          <div className="bg-slate-900 border border-slate-800 rounded-2xl p-12 text-center">
            <p className="text-4xl mb-3">🎉</p>
            <p className="text-white font-semibold">All caught up!</p>
            <p className="text-slate-400 text-sm mt-1">No applications pending review</p>
          </div>
        ) : (
          <div className="space-y-4">
            {loans.map((loan) => (
              <div key={loan.application_id} className="bg-slate-900 border border-slate-800 rounded-2xl p-6">
                <div className="flex items-start justify-between">
                  <div className="flex-1">
                    <div className="flex items-center gap-3 mb-2">
                      <span className="font-mono text-indigo-400 text-sm">{loan.application_number}</span>
                      <span className="px-2.5 py-0.5 rounded-full text-xs font-medium bg-amber-500/20 text-amber-400">{loan.status}</span>
                    </div>
                    <h3 className="text-white font-semibold text-lg">{loan.company_name}</h3>
                    <div className="flex items-center gap-6 mt-2 text-sm text-slate-400">
                      <span>📋 {loan.loan_type}</span>
                      <span>💰 ₹{(parseFloat(loan.requested_amount) / 100000).toFixed(1)}L</span>
                      <span>👤 {loan.officer_name}</span>
                      <span>📅 {new Date(loan.application_date).toLocaleDateString("en-IN")}</span>
                    </div>
                  </div>
                  <div className="flex items-center gap-3 ml-6">
                    <button
                      onClick={() => router.push(`/risk?id=${loan.application_id}`)}
                      className="px-4 py-2 text-sm border border-slate-700 text-slate-300 hover:bg-slate-800 rounded-xl transition-colors"
                    >
                      View Risk
                    </button>
                    <button
                      onClick={() => updateStatus(loan.application_id, "REJECTED")}
                      disabled={updating === loan.application_id}
                      className="px-4 py-2 text-sm bg-red-500/20 text-red-400 border border-red-500/30 hover:bg-red-500/30 rounded-xl transition-colors disabled:opacity-50"
                    >
                      ✕ Reject
                    </button>
                    <button
                      onClick={() => updateStatus(loan.application_id, "APPROVED")}
                      disabled={updating === loan.application_id}
                      className="px-4 py-2 text-sm bg-emerald-500/20 text-emerald-400 border border-emerald-500/30 hover:bg-emerald-500/30 rounded-xl transition-colors disabled:opacity-50"
                    >
                      ✓ Approve
                    </button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </main>
    </div>
  );
}