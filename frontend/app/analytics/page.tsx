"use client";
import { useEffect, useState } from "react";
import axios from "axios";
import Sidebar from "@/components/Navbar";
import { useRouter } from "next/navigation";
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, LineChart, Line, CartesianGrid } from "recharts";
import { API_BASE } from "@/lib/api";

export default function AnalyticsPage() {
  const router = useRouter();
  const [user, setUser] = useState<any>(null);
  const [loans, setLoans] = useState<any[]>([]);

  useEffect(() => {
    const stored = localStorage.getItem("aura_user");
    if (!stored) { router.push("/"); return; }
    setUser(JSON.parse(stored));
    axios.get(`${API_BASE}/api/loans/`).then((res) => setLoans(res.data.data));
  }, []);

  const byStatus = Object.entries(
    loans.reduce((acc: any, l) => { acc[l.status] = (acc[l.status] || 0) + 1; return acc; }, {})
  ).map(([name, value]) => ({ name, value }));

  const byType = Object.entries(
    loans.reduce((acc: any, l) => { acc[l.loan_type] = (acc[l.loan_type] || 0) + parseFloat(l.requested_amount || 0); return acc; }, {})
  ).map(([name, value]) => ({ name, value: Math.round((value as number) / 100000) }));

  const byMonth = Object.entries(
    loans.reduce((acc: any, l) => {
      const m = new Date(l.application_date).toLocaleDateString("en-IN", { month: "short", year: "2-digit" });
      acc[m] = (acc[m] || 0) + 1;
      return acc;
    }, {})
  ).map(([name, value]) => ({ name, value }));

  const tooltipStyle = { contentStyle: { background: "#1e293b", border: "1px solid #334155", borderRadius: "8px", color: "#f1f5f9" } };

  return (
    <div className="flex min-h-screen bg-slate-950">
      <Sidebar user={user} />
      <main className="ml-60 flex-1 p-8">
        <div className="mb-6">
          <h1 className="text-2xl font-bold text-white">Analytics</h1>
          <p className="text-slate-400 text-sm mt-1">Portfolio insights and trends</p>
        </div>

        <div className="grid grid-cols-2 gap-6 mb-6">
          <div className="bg-slate-900 border border-slate-800 rounded-2xl p-6">
            <h3 className="font-semibold text-white mb-4">Applications by Status</h3>
            <ResponsiveContainer width="100%" height={220}>
              <BarChart data={byStatus} barSize={28}>
                <XAxis dataKey="name" tick={{ fill: "#94a3b8", fontSize: 10 }} axisLine={false} tickLine={false} />
                <YAxis tick={{ fill: "#94a3b8", fontSize: 10 }} axisLine={false} tickLine={false} />
                <Tooltip {...tooltipStyle} />
                <Bar dataKey="value" fill="#6366f1" radius={[4, 4, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </div>

          <div className="bg-slate-900 border border-slate-800 rounded-2xl p-6">
            <h3 className="font-semibold text-white mb-4">Amount by Loan Type (₹L)</h3>
            <ResponsiveContainer width="100%" height={220}>
              <BarChart data={byType} barSize={28}>
                <XAxis dataKey="name" tick={{ fill: "#94a3b8", fontSize: 10 }} axisLine={false} tickLine={false} />
                <YAxis tick={{ fill: "#94a3b8", fontSize: 10 }} axisLine={false} tickLine={false} />
                <Tooltip {...tooltipStyle} />
                <Bar dataKey="value" fill="#10b981" radius={[4, 4, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </div>

        <div className="bg-slate-900 border border-slate-800 rounded-2xl p-6">
          <h3 className="font-semibold text-white mb-4">Applications Over Time</h3>
          <ResponsiveContainer width="100%" height={220}>
            <LineChart data={byMonth}>
              <CartesianGrid strokeDasharray="3 3" stroke="#1e293b" />
              <XAxis dataKey="name" tick={{ fill: "#94a3b8", fontSize: 10 }} axisLine={false} tickLine={false} />
              <YAxis tick={{ fill: "#94a3b8", fontSize: 10 }} axisLine={false} tickLine={false} />
              <Tooltip {...tooltipStyle} />
              <Line type="monotone" dataKey="value" stroke="#6366f1" strokeWidth={2} dot={{ fill: "#6366f1", r: 4 }} />
            </LineChart>
          </ResponsiveContainer>
        </div>
      </main>
    </div>
  );
}