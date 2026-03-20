<div align="center">

<img src="https://capsule-render.vercel.app/api?type=shark&color=0:000d1a,50:001f3f,100:000d1a&height=200&section=header&text=CYBERKIT&fontSize=80&fontColor=00b4ff&fontAlignY=55&animation=fadeIn&desc=v1.0%20%7C%20All-in-One%20Cybersecurity%20Toolkit%20%7C%2022%20Tools%20%7C%20One%20Script&descSize=14&descAlignY=75&descColor=4a9ebe"/>

</div>

<div align="center">

<img src="https://readme-typing-svg.demolab.com?font=JetBrains+Mono&weight=700&size=14&pause=800&color=00B4FF&center=true&vCenter=true&width=800&lines=root%40cyberkit+~%24+bash+cyberkit.sh;LOADING+22+CYBERSECURITY+TOOLS...;%5B+%E2%9C%93+%5D+Nmap+%7C+Masscan+%7C+Nikto+%7C+SQLMap;%5B+%E2%9C%93+%5D+Hydra+%7C+John+%7C+Hashcat+%7C+Nuclei;%5B+%E2%9C%93+%5D+ClamAV+%7C+Yara+%7C+Binwalk+%7C+Steghide;%5B+%E2%9C%93+%5D+Metasploit+%7C+TShark+%7C+Subfinder;%5B+ALL+SYSTEMS+OPERATIONAL+%5D+Select+a+tool+to+begin." alt="Typing SVG"/>

</div>

<br/>

<div align="center">

![Bash](https://img.shields.io/badge/Shell-Bash-00b4ff?style=flat-square&logo=gnubash&logoColor=white&labelColor=000d1a)
![Tools](https://img.shields.io/badge/Tools-22%20Integrated-00b4ff?style=flat-square&labelColor=000d1a)
![OS](https://img.shields.io/badge/OS-Ubuntu%20%7C%20Debian%20%7C%20Kali%20%7C%20Arch%20%7C%20Fedora-00b4ff?style=flat-square&labelColor=000d1a)
![License](https://img.shields.io/badge/License-MIT%202026-00b4ff?style=flat-square&labelColor=000d1a)
![Root](https://img.shields.io/badge/Requires-root%20%2F%20sudo-ff4444?style=flat-square&labelColor=000d1a)
![Ethics](https://img.shields.io/badge/Use-Ethical%20%26%20Legal%20Only-22c55e?style=flat-square&labelColor=000d1a)

</div>

---

## `>> WHAT IS CYBERKIT?`

```
A single bash script that auto-detects your OS, installs 22 industry-standard
cybersecurity tools, and launches them through a clean interactive menu.

No manual setup. No dependency hell. No switching terminals.
Just: sudo bash cyberkit.sh
```

> ⚠️ **For authorized testing, CTF challenges, and educational use only.**
> Always obtain permission before scanning or testing any system you do not own.

---

## `>> QUICK START`

```bash
# Clone
git clone https://github.com/Arunachalam-gojosaturo/cyberkit.git
cd cyberkit

# Make executable
chmod +x cyberkit.sh

# Launch (requires root)
sudo bash cyberkit.sh

# → Press [I] on first run to install all 22 tools
# → Then pick any tool from the menu and go
```

---

## `>> TOOL ARSENAL — 22 TOOLS`

<div align="center">

### 🔍 Network Recon

| `TOOL` | `PURPOSE` |
|---|---|
| **Nmap** | Network scanner — ports, services, OS detection |
| **Masscan** | Fastest mass IP/port scanner on the planet |
| **Subfinder** | Passive subdomain enumeration |
| **Amass** | OSINT-powered subdomain + asset discovery |
| **Httprobe** | Probe domains for live HTTP/HTTPS services |
| **DNSrecon** | Full DNS enumeration and zone walking |

### 🌐 Web Security

| `TOOL` | `PURPOSE` |
|---|---|
| **Nikto** | Web server misconfiguration + vulnerability scan |
| **SQLMap** | Automated SQL injection detection and exploitation |
| **Gobuster** | Fast directory, file and DNS brute forcing |
| **Dirb** | Web content scanner using wordlists |
| **WPScan** | WordPress vulnerability and user enumeration |
| **Nuclei** | Template-based fast vulnerability scanning |

### 🔑 Password Attacks

| `TOOL` | `PURPOSE` |
|---|---|
| **Hydra** | Network login brute forcer (SSH, FTP, HTTP...) |
| **John the Ripper** | CPU-based password hash cracker |
| **Hashcat** | GPU-accelerated hash cracker (MD5, SHA, bcrypt...) |

### 🔬 Forensics & Analysis

| `TOOL` | `PURPOSE` |
|---|---|
| **TShark** | CLI packet capture and deep analysis |
| **ClamAV** | Open-source malware and virus scanner |
| **Yara** | Pattern-based malware identification rules |
| **Steghide** | Embed/extract hidden data in images/audio |
| **Binwalk** | Firmware and binary file analysis + extraction |

### 💀 Exploitation

| `TOOL` | `PURPOSE` |
|---|---|
| **Metasploit** | Industry-standard exploitation framework |
| **Netcat** | Network swiss army knife — shells, transfer, scan |

</div>

---

## `>> INTERACTIVE MENU`

```
  ══ CYBERKIT v1.0 ══

  ─── SETUP ──────────────────────────────────
  [I]  Install All Tools
  [U]  Update All Tools
  [C]  Check Tool Status

  ─── NETWORK RECON ──────────────────────────
  [1]  Nmap          — Network Scanner
  [2]  Masscan       — Mass Port Scanner
  [3]  Subfinder     — Subdomain Discovery
  [4]  DNSrecon      — DNS Enumeration

  ─── WEB SECURITY ───────────────────────────
  [5]  Nikto         — Web Vulnerability Scan
  [6]  SQLMap        — SQL Injection
  [7]  Gobuster      — Directory Brute Force
  [8]  WPScan        — WordPress Scanner
  [9]  Nuclei        — Template Vuln Scan

  ─── PASSWORD ATTACKS ───────────────────────
  [10] Hydra         — Login Brute Forcer
  [11] John          — Password Cracker

  ─── FORENSICS & ANALYSIS ───────────────────
  [12] TShark        — Packet Capture
  [13] ClamAV        — Malware Scanner
  [14] Steghide      — Steganography
  [15] Binwalk       — Binary Analysis

  ─── EXPLOITATION ───────────────────────────
  [16] Metasploit    — Exploitation Framework

  ─── INFO ────────────────────────────────────
  [A]  About Creator
  [L]  View Install Log
  [Q]  Quit
```

---

## `>> OS COMPATIBILITY`

```
DISTRO FAMILY     PACKAGE MANAGER    TESTED
─────────────────────────────────────────────────
Ubuntu / Debian   apt-get            ✓ Supported
Kali Linux        apt-get            ✓ Supported
Parrot OS         apt-get            ✓ Supported
Arch / Manjaro    pacman             ✓ Supported
Fedora / RHEL     dnf                ✓ Supported
openSUSE          zypper             ✓ Supported
─────────────────────────────────────────────────
Auto-detected at runtime. No manual config needed.
```

---

## `>> ARCHITECTURE`

```
cyberkit.sh
│
├── SECTION 0 — Banner + Color system
├── SECTION 1 — Root privilege check
├── SECTION 2 — OS detection → sets PKG_INSTALL
├── SECTION 3 — Prerequisites (curl, git, go, ruby, pip...)
├── SECTION 4 — 22 tool installers (with source fallbacks)
├── SECTION 5 — Tool status checker
├── SECTION 6 — About the creator
├── SECTION 7 — Interactive tool launchers (guided prompts)
├── SECTION 8 — Update function
└── SECTION 9 — Main menu loop
```

---

## `>> FEATURES`

```
[✓]  Auto OS detection — Debian / Arch / Fedora / SUSE
[✓]  Smart install — skips already-installed tools
[✓]  Source fallbacks — builds from git if pkg unavailable
[✓]  Spinner animations — visual feedback during installs
[✓]  Guided launchers — prompts for target, options, wordlist
[✓]  Tool status checker — ✓ / ✗ for all 22 tools
[✓]  One-key update — refreshes all tools and signatures
[✓]  Full logging — everything saved to ~/cyberkit_install.log
[✓]  About section — creator profile and project showcase
```

---

## `>> LEGAL NOTICE`

```
This toolkit is intended for:
  ✓  CTF (Capture The Flag) competitions
  ✓  Penetration testing on systems you own
  ✓  Authorized security assessments
  ✓  Educational and learning environments
  ✓  Cybersecurity research

It is ILLEGAL to:
  ✗  Scan or test systems without explicit written permission
  ✗  Use these tools against live production systems
  ✗  Intercept network traffic you are not authorized to capture

The creator assumes no liability for misuse.
```

---

## `>> CREATOR`

<div align="center">

```
  BUILT BY   : ARUNACHALAM
  ALIAS      : gojosaturo
  BASE       : Vellore, Tamil Nadu 🇮🇳
  OS         : Arch Linux + Hyprland
  STACK      : Bash · Python · Linux · Cybersecurity · AI · Android
  MOTIVE     : One script to rule all security tools.
```

[![GitHub](https://img.shields.io/badge/GITHUB-Arunachalam--gojosaturo-00b4ff?style=for-the-badge&logo=github&logoColor=white&labelColor=000d1a)](https://github.com/Arunachalam-gojosaturo)
[![Instagram](https://img.shields.io/badge/INSTAGRAM-@saturogojo__ac-00b4ff?style=for-the-badge&logo=instagram&logoColor=white&labelColor=000d1a)](https://instagram.com/saturogojo_ac)

</div>

---

## `>> MORE PROJECTS`

<div align="center">

| `PROJECT` | `DESCRIPTION` | `REPO` |
|---|---|---|
| 🌙 **Luna AI** | WhatsApp AI agent — Groq + Voice + Telegram control | [→](https://github.com/Arunachalam-gojosaturo/luna-ai) |
| 🔴 **ARC-Network** | Full-stack cybersecurity web hub — JWT + admin panel | [→](https://github.com/Arunachalam-gojosaturo/arc-network) |
| 🟡 **Job Hunter v3** | Autonomous job scanner — Reddit + Upwork + 5 alert channels | [→](https://github.com/Arunachalam-gojosaturo/job-hunter-agent-v3) |
| 🐧 **Hyprland Dots** | Iron Man arc-reactor themed Arch Linux dotfiles | [→](https://github.com/Arunachalam-gojosaturo/hyprland-dots) |

</div>

---

<div align="center">

*Use responsibly. Learn deeply. Break ethically.*

<img src="https://capsule-render.vercel.app/api?type=shark&color=0:000d1a,50:001f3f,100:000d1a&height=100&section=footer&text=CYBERKIT+v1.0+%7C+BUILT+BY+ARUNACHALAM&fontSize=15&fontColor=00b4ff&animation=fadeIn"/>

</div>
