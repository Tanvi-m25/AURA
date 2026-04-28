"use client";
import { useEffect, useState } from "react";
import axios from "axios";
import Sidebar from "@/components/Navbar";
import { useRouter } from "next/navigation";
import { PieChart, Pie, Cell, ResponsiveContainer, Tooltip, BarChart, Bar, XAxis, YAxis } from "recharts";
import { API_BASE } from "@/lib/api";

export default function DashboardPage() {
  const router = useRouter();
  const [user, setUser] = useState<any>(null);
  const [loans, setLoans] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const stored = localStorage.getItem("aura_user");
    if (!stored) { router.push("/"); return; }
    setUser(JSON.parse(stored));
    axios.get(`${API_BASE}/api/loans/`).then((res) => {
      setLoans(res.data.data);
      setLoading(false);
    });
  }, []);

  const stats = {
    total: loans.length,
    approved: loans.filter((l) => ["APPROVED","DISBURSED"].includes(l.status)).length,
    pending: loans.filter((l) => ["SUBMITTED","UNDER_REVIEW","RISK_ASSESSMENT"].includes(l.status)).length,
    rejected: loans.filter((l) => l.status === "REJECTED").length,
    totalAmount: loans.reduce((sum, l) => sum + parseFloat(l.requested_amount || 0), 0),
  };

  const pieData = [
    { name: "Approved", value: stats.approved, color: "#10b981" },
    { name: "Pending", value: stats.pending, color: "#f59e0b" },
    { name: "Rejected", value: stats.rejected, color: "#ef4444" },
  ].filter(d => d.value > 0);

  const typeData = Object.entries(
    loans.reduce((acc: any, l) => {
      acc[l.loan_type] = (acc[l.loan_type] || 0) + 1;
      return acc;
    }, {})
  ).map(([name, value]) => ({ name, value }));

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

  const statCards = [
    { label: "Total Applications", value: stats.total, icon: "📋", color: "text-indigo-400", border: "border-indigo-500/20", bg: "bg-indigo-500/5" },
    { label: "Approved", value: stats.approved, icon: "✅", color: "text-emerald-400", border: "border-emerald-500/20", bg: "bg-emerald-500/5" },
    { label: "Pending Review", value: stats.pending, icon: "⏳", color: "text-amber-400", border: "border-amber-500/20", bg: "bg-amber-500/5" },
    { label: "Rejected", value: stats.rejected, icon: "❌", color: "text-red-400", border: "border-red-500/20", bg: "bg-red-500/5" },
  ];

  return (
    <div className="flex min-h-screen bg-slate-950">
      <Sidebar user={user} />
      <main className="ml-60 flex-1 p-8">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-2xl font-bold text-white">Good morning, {user?.name?.split(" ")[0]} 👋</h1>
          <p className="text-slate-400 text-sm mt-1">Here's your portfolio overview for today</p>
        </div>

        {/* Stat cards */}
        <div className="grid grid-cols-4 gap-4 mb-8">
          {statCards.map((s) => (
            <div key={s.label} className={`${s.bg} border ${s.border} rounded-2xl p-5`}>
              <div className="flex items-center justify-between mb-3">
                <span className="text-2xl">{s.icon}</span>
                <span className={`text-3xl font-bold ${s.color}`}>{s.value}</span>
              </div>
              <p className="text-slate-400 text-sm">{s.label}</p>
            </div>
          ))}
        </div>

        {/* Portfolio value banner */}
        <div className="bg-gradient-to-r from-indigo-600/20 to-violet-600/20 border border-indigo-500/20 rounded-2xl p-6 mb-8">
          <p className="text-slate-400 text-sm mb-1">Total Portfolio Value</p>
          <p className="text-4xl font-bold text-white">₹{(stats.totalAmount / 10000000).toFixed(2)} Cr</p>
          <p className="text-indigo-400 text-sm mt-1">Across {stats.total} loan applications</p>
        </div>

        {/* Charts row */}
        <div className="grid grid-cols-2 gap-6 mb-8">
          <div className="bg-slate-900 border border-slate-800 rounded-2xl p-6">
            <h3 className="text-white font-semibold mb-4">Application Status</h3>
            {!loading && pieData.length > 0 && (
              <ResponsiveContainer width="100%" height={200}>
                <PieChart>
                  <Pie data={pieData} cx="50%" cy="50%" innerRadius={60} outerRadius={90} paddingAngle={3} dataKey="value">
                    {pieData.map((entry, i) => <Cell key={i} fill={entry.color} />)}
                  </Pie>
                  <Tooltip contentStyle={{ background: "#1e293b", border: "1px solid #334155", borderRadius: "8px", color: "#f1f5f9" }} />
                </PieChart>
              </ResponsiveContainer>
            )}
            <div className="flex gap-4 justify-center mt-2">
              {pieData.map((d) => (
                <div key={d.name} className="flex items-center gap-1.5 text-xs text-slate-400">
                  <div className="w-2.5 h-2.5 rounded-full" style={{ background: d.color }} />
                  {d.name}
                </div>
              ))}
            </div>
          </div>

          <div className="bg-slate-900 border border-slate-800 rounded-2xl p-6">
            <h3 className="text-white font-semibold mb-4">Loans by Type</h3>
            {!loading && (
              <ResponsiveContainer width="100%" height={200}>
                <BarChart data={typeData} barSize={32}>
                  <XAxis dataKey="name" tick={{ fill: "#94a3b8", fontSize: 10 }} axisLine={false} tickLine={false} />
                  <YAxis tick={{ fill: "#94a3b8", fontSize: 10 }} axisLine={false} tickLine={false} />
                  <Tooltip contentStyle={{ background: "#1e293b", border: "1px solid #334155", borderRadius: "8px", color: "#f1f5f9" }} />
                  <Bar dataKey="value" fill="#6366f1" radius={[4, 4, 0, 0]} />
                </BarChart>
              </ResponsiveContainer>
            )}
          </div>
        </div>

        {/* Recent table */}
        <div className="bg-slate-900 border border-slate-800 rounded-2xl">
          <div className="px-6 py-4 border-b border-slate-800 flex justify-between items-center">
            <h3 className="font-semibold text-white">Recent Applications</h3>
            <button onClick={() => router.push("/loans")} className="text-sm text-indigo-400 hover:text-indigo-300 transition-colors">View all →</button>
          </div>
          {loading ? (
            <div className="p-8 text-center text-slate-500">Loading...</div>
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="border-b border-slate-800">
                    {["Application #", "Company", "Type", "Amount", "Status"].map(h => (
                      <th key={h} className="text-left px-6 py-3 text-slate-500 font-medium text-xs uppercase tracking-wider">{h}</th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {loans.slice(0, 6).map((loan) => (
                    <tr key={loan.application_id} className="border-b border-slate-800/50 hover:bg-slate-800/30 transition-colors cursor-pointer" onClick={() => router.push(`/risk?id=${loan.application_id}`)}>
                      <td className="px-6 py-3 font-mono text-indigo-400 text-xs">{loan.application_number}</td>
                      <td className="px-6 py-3 text-white font-medium">{loan.company_name}</td>
                      <td className="px-6 py-3 text-slate-400">{loan.loan_type}</td>
                      <td className="px-6 py-3 text-white">₹{(parseFloat(loan.requested_amount) / 100000).toFixed(1)}L</td>
                      <td className="px-6 py-3">
                        <span className={`px-2.5 py-1 rounded-full text-xs font-medium ${statusColor[loan.status] || statusColor.SUBMITTED}`}>
                          {loan.status}
                        </span>
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