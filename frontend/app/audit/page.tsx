"use client";
import { useEffect, useState } from "react";
import axios from "axios";
import Sidebar from "@/components/Navbar";
import { useRouter } from "next/navigation";

export default function AuditPage() {
  const router = useRouter();
  const [user, setUser] = useState<any>(null);
  const [logs, setLogs] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const stored = localStorage.getItem("aura_user");
    if (!stored) { router.push("/"); return; }
    setUser(JSON.parse(stored));
    axios.get("http://localhost:5000/api/audit/").then((res) => {
      setLogs(res.data.data);
      setLoading(false);
    });
  }, []);

  const actionColor: any = {
    APPLICATION_CREATED: "bg-blue-500/20 text-blue-400",
    STATUS_CHANGE: "bg-amber-500/20 text-amber-400",
    RISK_ASSESSED: "bg-purple-500/20 text-purple-400",
    APPROVED: "bg-emerald-500/20 text-emerald-400",
    REJECTED: "bg-red-500/20 text-red-400",
  };

  return (
    <div className="flex min-h-screen bg-slate-950">
      <Sidebar user={user} />
      <main className="ml-60 flex-1 p-8 overflow-y-auto">
        <div className="mb-6">
          <h1 className="text-2xl font-bold text-white">Audit Log</h1>
          <p className="text-slate-400 text-sm mt-1">Complete trail of all system actions</p>
        </div>

        <div className="bg-slate-900 border border-slate-800 rounded-2xl overflow-hidden">
          <div className="px-6 py-4 border-b border-slate-800 flex items-center justify-between">
            <p className="text-white font-semibold">System Events</p>
            <span className="text-xs text-slate-500 bg-slate-800 px-3 py-1 rounded-full">{logs.length} records</span>
          </div>

          {loading ? (
            <div className="p-12 text-center text-slate-500">Loading...</div>
          ) : logs.length === 0 ? (
            <div className="p-12 text-center text-slate-500">No audit records found</div>
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="border-b border-slate-800 bg-slate-800/30">
                    {["Time", "Application #", "Action", "Performed By", "Details"].map(h => (
                      <th key={h} className="text-left px-6 py-3 text-slate-500 font-medium text-xs uppercase tracking-wider whitespace-nowrap">{h}</th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {logs.map((log, i) => (
                    <tr key={log.log_id || i} className="border-b border-slate-800/50 hover:bg-slate-800/30 transition-colors">
                      <td className="px-6 py-4 text-slate-400 text-xs whitespace-nowrap">
                        {new Date(log.created_at).toLocaleString("en-IN", { day: "2-digit", month: "short", hour: "2-digit", minute: "2-digit" })}
                      </td>
                      <td className="px-6 py-4 font-mono text-indigo-400 text-xs whitespace-nowrap">
                        {log.application_number || "—"}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <span className={`px-2.5 py-1 rounded-full text-xs font-medium ${actionColor[log.action] || "bg-slate-500/20 text-slate-400"}`}>
                          {log.action}
                        </span>
                      </td>
                      <td className="px-6 py-4 text-slate-300 text-xs">{log.performed_by || "—"}</td>
                      <td className="px-6 py-4 text-slate-400 text-xs">{log.new_value || log.old_value || "—"}</td>
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