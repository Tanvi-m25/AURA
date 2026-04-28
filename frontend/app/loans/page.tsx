"use client";
import { useEffect, useState } from "react";
import axios from "axios";
import Sidebar from "@/components/Navbar";
import { useRouter } from "next/navigation";
import { API_BASE } from "@/lib/api";

export default function LoansPage() {
  const router = useRouter();
  const [user, setUser] = useState<any>(null);
  const [loans, setLoans] = useState<any[]>([]);
  const [filtered, setFiltered] = useState<any[]>([]);
  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState("ALL");
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const stored = localStorage.getItem("aura_user");
    if (!stored) { router.push("/"); return; }
    setUser(JSON.parse(stored));
    axios.get(`${API_BASE}/api/loans/`).then((res) => {
      setLoans(res.data.data);
      setFiltered(res.data.data);
      setLoading(false);
    });
  }, []);

  useEffect(() => {
    let result = loans;
    if (statusFilter !== "ALL") result = result.filter((l) => l.status === statusFilter);
    if (search) result = result.filter((l) =>
      l.company_name.toLowerCase().includes(search.toLowerCase()) ||
      l.application_number.toLowerCase().includes(search.toLowerCase())
    );
    setFiltered(result);
  }, [search, statusFilter, loans]);

  const statusColor: any = {
    APPROVED: "bg-emerald-500/20 text-emerald-400",
    DISBURSED: "bg-blue-500/20 text-blue-400",
    REJECTED: "bg-red-500/20 text-red-400",
    SUBMITTED: "bg-slate-500/20 text-slate-400",
    UNDER_REVIEW: "bg-amber-500/20 text-amber-400",
    RISK_ASSESSMENT: "bg-purple-500/20 text-purple-400",
    CANCELLED: "bg-slate-500/20 text-slate-500",
    TERM_LOAN: "bg-slate-500/20 text-slate-400",
  };

  return (
    <div className="flex min-h-screen bg-slate-950">
      <Sidebar user={user} />
      <main className="ml-60 flex-1 p-8">
        <div className="mb-6">
          <h1 className="text-2xl font-bold text-white">Loan Applications</h1>
          <p className="text-slate-400 text-sm mt-1">{filtered.length} applications found</p>
        </div>

        <div className="bg-slate-900 border border-slate-800 rounded-2xl">
          <div className="px-6 py-4 border-b border-slate-800 flex gap-3">
            <input
              type="text"
              placeholder="Search company or application number..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="flex-1 px-4 py-2 rounded-xl border border-slate-700 bg-slate-800 text-white placeholder-slate-500 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
            />
            <select
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value)}
              className="px-4 py-2 rounded-xl border border-slate-700 bg-slate-800 text-white text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
            >
              <option value="ALL">All Status</option>
              <option value="SUBMITTED">Submitted</option>
              <option value="UNDER_REVIEW">Under Review</option>
              <option value="RISK_ASSESSMENT">Risk Assessment</option>
              <option value="APPROVED">Approved</option>
              <option value="DISBURSED">Disbursed</option>
              <option value="REJECTED">Rejected</option>
              <option value="CANCELLED">Cancelled</option>
            </select>
          </div>
          {loading ? (
            <div className="p-8 text-center text-slate-500">Loading...</div>
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="border-b border-slate-800">
                    {["Application #", "Company", "Loan Type", "Amount", "Officer", "Date", "Status", "Action"].map(h => (
                      <th key={h} className="text-left px-6 py-3 text-slate-500 font-medium text-xs uppercase tracking-wider">{h}</th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {filtered.map((loan) => (
                    <tr key={loan.application_id} className="border-b border-slate-800/50 hover:bg-slate-800/30 transition-colors">
                      <td className="px-6 py-3 font-mono text-indigo-400 text-xs">{loan.application_number}</td>
                      <td className="px-6 py-3 text-white font-medium">{loan.company_name}</td>
                      <td className="px-6 py-3 text-slate-400">{loan.loan_type}</td>
                      <td className="px-6 py-3 text-white font-medium">₹{(parseFloat(loan.requested_amount) / 100000).toFixed(1)}L</td>
                      <td className="px-6 py-3 text-slate-400">{loan.officer_name}</td>
                      <td className="px-6 py-3 text-slate-400">{new Date(loan.application_date).toLocaleDateString("en-IN")}</td>
                      <td className="px-6 py-3">
                        <span className={`px-2.5 py-1 rounded-full text-xs font-medium ${statusColor[loan.status] || statusColor.SUBMITTED}`}>
                          {loan.status}
                        </span>
                      </td>
                      <td className="px-6 py-3">
                        <button
                          onClick={() => router.push(`/risk?id=${loan.application_id}`)}
                          className="text-xs px-3 py-1.5 bg-indigo-600 hover:bg-indigo-500 text-white rounded-lg transition-colors"
                        >
                          Analyze →
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
      </main>
    </div>
  );
}