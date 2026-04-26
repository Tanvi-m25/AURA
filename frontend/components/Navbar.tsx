"use client";
import { useTheme } from "next-themes";
import { useEffect, useState } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";

const navItems = [
  { href: "/dashboard", icon: "⬡", label: "Dashboard" },
  { href: "/loans", icon: "📋", label: "Loan Applications" },
  { href: "/risk", icon: "🔍", label: "Risk Analysis" },
  { href: "/approval", icon: "✅", label: "Approval Workflow" },
  { href: "/termsheet", icon: "📄", label: "Term Sheet" },
  { href: "/ratios", icon: "📊", label: "Financial Ratios" },
  { href: "/analytics", icon: "📈", label: "Analytics" },
  { href: "/audit", icon: "🗒️", label: "Audit Log" },
];

export default function Sidebar({ user }: { user?: any }) {
  const { theme, setTheme } = useTheme();
  const [mounted, setMounted] = useState(false);
  const pathname = usePathname();
  useEffect(() => setMounted(true), []);

  return (
    <aside className="fixed left-0 top-0 h-full w-60 bg-slate-950 border-r border-slate-800 flex flex-col z-40">
      {/* Logo */}
      <div className="px-6 py-5 border-b border-slate-800">
        <div className="flex items-center gap-3">
          <div className="w-8 h-8 rounded-lg bg-indigo-600 flex items-center justify-center text-white font-bold text-sm shadow-lg shadow-indigo-500/30">◈</div>
          <div>
            <p className="font-bold text-white text-sm tracking-wide">AURA</p>
            <p className="text-slate-500 text-xs">Risk Platform</p>
          </div>
        </div>
      </div>

      {/* Nav */}
      <nav className="flex-1 px-3 py-4 space-y-0.5 overflow-y-auto">
        {navItems.map((item) => {
          const active = pathname === item.href;
          return (
            <Link key={item.href} href={item.href}
              className={`flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-medium transition-all ${
                active
                  ? "bg-indigo-600 text-white shadow-lg shadow-indigo-500/20"
                  : "text-slate-400 hover:text-white hover:bg-slate-800"
              }`}
            >
              <span className="text-base">{item.icon}</span>
              {item.label}
            </Link>
          );
        })}
      </nav>

      {/* Bottom */}
      <div className="px-3 py-4 border-t border-slate-800 space-y-2">
        {mounted && (
          <button
            onClick={() => setTheme(theme === "dark" ? "light" : "dark")}
            className="w-full flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm text-slate-400 hover:text-white hover:bg-slate-800 transition-all"
          >
            <span>{theme === "dark" ? "☀️" : "🌙"}</span>
            {theme === "dark" ? "Light Mode" : "Dark Mode"}
          </button>
        )}
        {user && (
          <>
            <div className="px-3 py-2">
              <p className="text-white text-sm font-medium truncate">{user.name}</p>
              <p className="text-slate-500 text-xs truncate">{user.email}</p>
              <span className={`inline-block mt-1 text-xs px-2 py-0.5 rounded-full font-medium ${
                user.role === 'ADMIN' ? 'bg-red-500/20 text-red-400' :
                user.role === 'MANAGER' ? 'bg-amber-500/20 text-amber-400' :
                'bg-emerald-500/20 text-emerald-400'
              }`}>{user.role}</span>
            </div>
            <button
              onClick={() => { localStorage.removeItem("aura_user"); window.location.href = "/"; }}
              className="w-full flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm text-slate-400 hover:text-red-400 hover:bg-red-500/10 transition-all"
            >
              <span>🚪</span> Sign Out
            </button>
          </>
        )}
      </div>
    </aside>
  );
}