"use client";
import { useState } from "react";
import Sidebar from "@/components/Navbar";

export default function RatiosPage() {
  const [user] = useState(() => {
    if (typeof window !== "undefined") return JSON.parse(localStorage.getItem("aura_user") || "{}");
    return {};
  });

  const [form, setForm] = useState({
    ebitda: "", totalDebt: "", annualDebtService: "", totalAssets: "",
    totalEquity: "", currentAssets: "", currentLiabilities: "", netIncome: "", revenue: "",
  });

  const set = (k: string, v: string) => setForm(f => ({ ...f, [k]: v }));

  const n = (k: string) => parseFloat(form[k as keyof typeof form]) || 0;

  const ratios = {
    dscr: n("annualDebtService") > 0 ? (n("ebitda") / n("annualDebtService")).toFixed(2) : null,
    leverage: n("totalEquity") > 0 ? (n("totalDebt") / n("totalEquity")).toFixed(2) : null,
    currentRatio: n("currentLiabilities") > 0 ? (n("currentAssets") / n("currentLiabilities")).toFixed(2) : null,
    roa: n("totalAssets") > 0 ? ((n("netIncome") / n("totalAssets")) * 100).toFixed(2) : null,
    netMargin: n("revenue") > 0 ? ((n("netIncome") / n("revenue")) * 100).toFixed(2) : null,
  };

  const getRating = (key: string, val: number) => {
    if (key === "dscr") return val >= 1.5 ? "good" : val >= 1.0 ? "warn" : "bad";
    if (key === "leverage") return val <= 2 ? "good" : val <= 4 ? "warn" : "bad";
    if (key === "currentRatio") return val >= 2 ? "good" : val >= 1 ? "warn" : "bad";
    if (key === "roa") return val >= 5 ? "good" : val >= 2 ? "warn" : "bad";
    if (key === "netMargin") return val >= 10 ? "good" : val >= 5 ? "warn" : "bad";
    return "warn";
  };

  const ratingStyle: any = {
    good: "text-emerald-400 bg-emerald-500/10 border-emerald-500/20",
    warn: "text-amber-400 bg-amber-500/10 border-amber-500/20",
    bad: "text-red-400 bg-red-500/10 border-red-500/20",
  };

  const inputs = [
    { key: "ebitda", label: "EBITDA (₹)" },
    { key: "totalDebt", label: "Total Debt (₹)" },
    { key: "annualDebtService", label: "Annual Debt Service (₹)" },
    { key: "totalAssets", label: "Total Assets (₹)" },
    { key: "totalEquity", label: "Total Equity (₹)" },
    { key: "currentAssets", label: "Current Assets (₹)" },
    { key: "currentLiabilities", label: "Current Liabilities (₹)" },
    { key: "netIncome", label: "Net Income (₹)" },
    { key: "revenue", label: "Revenue (₹)" },
  ];

  const results = [
    { key: "dscr", label: "DSCR", desc: "Debt Service Coverage Ratio", unit: "x", good: "≥ 1.5x" },
    { key: "leverage", label: "Leverage", desc: "Debt / Equity", unit: "x", good: "≤ 2x" },
    { key: "currentRatio", label: "Current Ratio", desc: "Current Assets / Liabilities", unit: "x", good: "≥ 2x" },
    { key: "roa", label: "ROA", desc: "Return on Assets", unit: "%", good: "≥ 5%" },
    { key: "netMargin", label: "Net Margin", desc: "Net Income / Revenue", unit: "%", good: "≥ 10%" },
  ];

  return (
    <div className="flex min-h-screen bg-slate-950">
      <Sidebar user={user} />
      <main className="ml-60 flex-1 p-8">
        <div className="mb-6">
          <h1 className="text-2xl font-bold text-white">Financial Ratios Calculator</h1>
          <p className="text-slate-400 text-sm mt-1">Enter financial data to compute key credit ratios</p>
        </div>

        <div className="grid grid-cols-2 gap-8">
          <div className="bg-slate-900 border border-slate-800 rounded-2xl p-6">
            <h2 className="font-semibold text-white mb-4">Input Data</h2>
            <div className="space-y-3">
              {inputs.map(({ key, label }) => (
                <div key={key}>
                  <label className="block text-xs text-slate-400 mb-1">{label}</label>
                  <input
                    type="number"
                    value={form[key as keyof typeof form]}
                    onChange={(e) => set(key, e.target.value)}
                    className="w-full px-3 py-2 rounded-lg border border-slate-700 bg-slate-800 text-white text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
                    placeholder="0"
                  />
                </div>
              ))}
            </div>
          </div>

          <div className="bg-slate-900 border border-slate-800 rounded-2xl p-6">
            <h2 className="font-semibold text-white mb-4">Computed Ratios</h2>
            <div className="space-y-3">
              {results.map(({ key, label, desc, unit, good }) => {
                const val = ratios[key as keyof typeof ratios];
                const rating = val ? getRating(key, parseFloat(val)) : null;
                return (
                  <div key={key} className={`border rounded-xl p-4 ${rating ? ratingStyle[rating] : "border-slate-700 bg-slate-800/50"}`}>
                    <div className="flex justify-between items-start">
                      <div>
                        <p className="font-semibold text-white text-sm">{label}</p>
                        <p className="text-xs text-slate-400">{desc}</p>
                      </div>
                      <div className="text-right">
                        <p className="text-2xl font-bold">{val ? `${val}${unit}` : "—"}</p>
                        <p className="text-xs text-slate-500">Healthy: {good}</p>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}