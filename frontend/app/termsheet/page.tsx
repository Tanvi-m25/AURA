"use client";
import { useEffect, useState } from "react";
import axios from "axios";
import Sidebar from "@/components/Navbar";
import { useRouter } from "next/navigation";
import { API_BASE } from "@/lib/api";

export default function TermSheetPage() {
  const router = useRouter();
  const [user, setUser] = useState<any>(null);
  const [loans, setLoans] = useState<any[]>([]);
  const [selected, setSelected] = useState<any>(null);
  const [form, setForm] = useState({
    interestRate: "12",
    tenureMonths: "60",
    collateral: "Yes",
    remarks: "",
  });

  useEffect(() => {
    const stored = localStorage.getItem("aura_user");
    if (!stored) { router.push("/"); return; }
    setUser(JSON.parse(stored));
    axios.get(`${API_BASE}/api/loans/`).then((res) => {
      setLoans(res.data.data.filter((l: any) => l.status === "APPROVED"));
    });
  }, []);

  const emi = () => {
    const p = parseFloat(selected?.requested_amount || 0);
    const r = parseFloat(form.interestRate) / 100 / 12;
    const n = parseInt(form.tenureMonths);
    if (!p || !r || !n) return 0;
    return (p * r * Math.pow(1 + r, n)) / (Math.pow(1 + r, n) - 1);
  };

  const handlePrint = () => {
    window.print();
  };

  return (
    <>
      {/* Print styles */}
      <style>{`
        @media print {
          .no-print { display: none !important; }
          .print-area {
            position: fixed !important;
            top: 0 !important;
            left: 0 !important;
            width: 100% !important;
            height: 100% !important;
            background: white !important;
            z-index: 9999 !important;
            padding: 40px !important;
          }
          body { background: white !important; }
        }
      `}</style>

      <div className="flex min-h-screen bg-slate-950">
        <div className="no-print">
          <Sidebar user={user} />
        </div>

        <main className="ml-60 flex-1 p-8 no-print">
          <div className="mb-6">
            <h1 className="text-2xl font-bold text-white">Term Sheet Generator</h1>
            <p className="text-slate-400 text-sm mt-1">Generate professional term sheets for approved loans</p>
          </div>

          <div className="grid grid-cols-5 gap-6">
            {/* Loan selector */}
            <div className="col-span-2 bg-slate-900 border border-slate-800 rounded-2xl p-5">
              <h2 className="font-semibold text-white mb-4 text-sm uppercase tracking-wider">Select Approved Loan</h2>
              {loans.length === 0 ? (
                <div className="text-center py-8">
                  <p className="text-4xl mb-2">📋</p>
                  <p className="text-slate-400 text-sm">No approved loans found</p>
                </div>
              ) : (
                <div className="space-y-2 max-h-96 overflow-y-auto pr-1">
                  {loans.map((loan) => (
                    <button
                      key={loan.application_id}
                      onClick={() => setSelected(loan)}
                      className={`w-full text-left px-4 py-3 rounded-xl border transition-all ${
                        selected?.application_id === loan.application_id
                          ? "border-indigo-500 bg-indigo-500/10"
                          : "border-slate-700 bg-slate-800/40 hover:border-slate-600"
                      }`}
                    >
                      <p className={`font-semibold text-sm ${selected?.application_id === loan.application_id ? "text-white" : "text-slate-300"}`}>
                        {loan.company_name}
                      </p>
                      <p className="text-xs text-slate-500 mt-0.5">
                        {loan.application_number} · ₹{(parseFloat(loan.requested_amount) / 100000).toFixed(1)}L
                      </p>
                    </button>
                  ))}
                </div>
              )}

              {selected && (
                <div className="mt-5 pt-5 border-t border-slate-800 space-y-3">
                  <h3 className="text-xs font-semibold text-slate-400 uppercase tracking-wider">Loan Terms</h3>
                  {[
                    { label: "Interest Rate (%)", key: "interestRate", placeholder: "12" },
                    { label: "Tenure (Months)", key: "tenureMonths", placeholder: "60" },
                    { label: "Collateral Required", key: "collateral", placeholder: "Yes" },
                    { label: "Remarks", key: "remarks", placeholder: "Optional remarks..." },
                  ].map(({ label, key, placeholder }) => (
                    <div key={key}>
                      <label className="block text-xs text-slate-500 mb-1">{label}</label>
                      <input
                        value={form[key as keyof typeof form]}
                        onChange={(e) => setForm(f => ({ ...f, [key]: e.target.value }))}
                        placeholder={placeholder}
                        className="w-full px-3 py-2 rounded-lg border border-slate-700 bg-slate-800 text-white text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500"
                      />
                    </div>
                  ))}
                  <button
                    onClick={handlePrint}
                    className="w-full mt-2 py-2.5 bg-indigo-600 hover:bg-indigo-500 text-white font-semibold rounded-xl transition-colors text-sm"
                  >
                    🖨️ Print / Save as PDF
                  </button>
                </div>
              )}
            </div>

            {/* Term sheet preview */}
            <div className="col-span-3">
              {!selected ? (
                <div className="bg-slate-900 border border-slate-800 rounded-2xl p-12 text-center h-full flex flex-col items-center justify-center">
                  <p className="text-5xl mb-4">📄</p>
                  <p className="text-white font-semibold">No loan selected</p>
                  <p className="text-slate-400 text-sm mt-1">Select an approved loan to generate a term sheet</p>
                </div>
              ) : (
                <div className="bg-white rounded-2xl shadow-2xl overflow-hidden print-area">
                  {/* Header */}
                  <div className="bg-slate-900 px-8 py-6">
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-3">
                        <div className="w-10 h-10 rounded-xl bg-indigo-600 flex items-center justify-center text-white font-bold text-lg">◈</div>
                        <div>
                          <p className="text-white font-bold text-xl tracking-tight">AURA BANK</p>
                          <p className="text-slate-400 text-xs">AI Unified Risk & Origination</p>
                        </div>
                      </div>
                      <div className="text-right">
                        <p className="text-white font-bold text-lg">TERM SHEET</p>
                        <p className="text-slate-400 text-xs">{new Date().toLocaleDateString("en-IN", { day: "2-digit", month: "long", year: "numeric" })}</p>
                        <p className="text-red-400 text-xs font-medium mt-1">CONFIDENTIAL</p>
                      </div>
                    </div>
                  </div>

                  {/* Borrower info banner */}
                  <div className="bg-indigo-600 px-8 py-4">
                    <p className="text-indigo-200 text-xs font-medium uppercase tracking-wider">Borrower</p>
                    <p className="text-white text-xl font-bold mt-0.5">{selected.company_name}</p>
                    <p className="text-indigo-200 text-sm">{selected.application_number} · {selected.loan_type}</p>
                  </div>

                  {/* Body */}
                  <div className="px-8 py-6 bg-white">
                    <p className="text-xs text-gray-400 uppercase tracking-wider font-semibold mb-4">Loan Terms & Conditions</p>

                    <div className="grid grid-cols-2 gap-px bg-gray-100 rounded-xl overflow-hidden border border-gray-200">
                      {[
                        { label: "Loan Amount", value: `₹${(parseFloat(selected.requested_amount) / 100000).toFixed(2)} Lakhs` },
                        { label: "Loan Type", value: selected.loan_type },
                        { label: "Interest Rate", value: `${form.interestRate}% per annum` },
                        { label: "Repayment Tenure", value: `${form.tenureMonths} months` },
                        { label: "Monthly EMI", value: `₹${emi().toLocaleString("en-IN", { maximumFractionDigits: 0 })}` },
                        { label: "Collateral Required", value: form.collateral },
                        { label: "Processing Officer", value: user?.name },
                        { label: "Officer Designation", value: user?.designation || "Loan Officer" },
                      ].map(({ label, value }) => (
                        <div key={label} className="bg-white px-5 py-3.5">
                          <p className="text-gray-400 text-xs font-medium uppercase tracking-wider">{label}</p>
                          <p className="text-gray-900 font-semibold text-sm mt-0.5">{value}</p>
                        </div>
                      ))}
                    </div>

                    {/* Financial summary */}
                    <div className="mt-5 bg-slate-50 rounded-xl p-5 border border-slate-200">
                      <p className="text-xs text-gray-400 uppercase tracking-wider font-semibold mb-3">Financial Summary</p>
                      <div className="grid grid-cols-3 gap-4">
                        <div className="text-center">
                          <p className="text-2xl font-bold text-indigo-600">₹{(parseFloat(selected.requested_amount) / 100000).toFixed(1)}L</p>
                          <p className="text-gray-500 text-xs mt-0.5">Principal Amount</p>
                        </div>
                        <div className="text-center border-x border-slate-200">
                          <p className="text-2xl font-bold text-emerald-600">{form.interestRate}%</p>
                          <p className="text-gray-500 text-xs mt-0.5">Annual Interest</p>
                        </div>
                        <div className="text-center">
                          <p className="text-2xl font-bold text-amber-600">
                            ₹{((emi() * parseInt(form.tenureMonths) - parseFloat(selected.requested_amount)) / 100000).toFixed(1)}L
                          </p>
                          <p className="text-gray-500 text-xs mt-0.5">Total Interest</p>
                        </div>
                      </div>
                    </div>

                    {form.remarks && (
                      <div className="mt-4 bg-amber-50 border border-amber-200 rounded-xl p-4">
                        <p className="text-xs text-amber-600 font-semibold uppercase tracking-wider mb-1">Remarks</p>
                        <p className="text-gray-700 text-sm">{form.remarks}</p>
                      </div>
                    )}

                    {/* Signatures */}
                    <div className="mt-6 pt-6 border-t border-gray-200">
                      <p className="text-xs text-gray-400 uppercase tracking-wider font-semibold mb-4">Authorized Signatures</p>
                      <div className="grid grid-cols-2 gap-8">
                        <div>
                          <div className="h-12 border-b-2 border-gray-300 mb-2"></div>
                          <p className="text-gray-700 text-sm font-semibold">{user?.name}</p>
                          <p className="text-gray-400 text-xs">Loan Officer · AURA Bank</p>
                        </div>
                        <div>
                          <div className="h-12 border-b-2 border-gray-300 mb-2"></div>
                          <p className="text-gray-700 text-sm font-semibold">Authorized Signatory</p>
                          <p className="text-gray-400 text-xs">Borrower · {selected.company_name}</p>
                        </div>
                      </div>
                    </div>

                    {/* Footer */}
                    <div className="mt-6 pt-4 border-t border-gray-100 flex items-center justify-between">
                      <p className="text-gray-300 text-xs">Generated by AURA · {new Date().toLocaleString("en-IN")}</p>
                      <p className="text-gray-300 text-xs">This document is confidential and not for distribution</p>
                    </div>
                  </div>
                </div>
              )}
            </div>
          </div>
        </main>
      </div>
    </>
  );
}