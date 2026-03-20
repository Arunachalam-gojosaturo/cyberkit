#!/bin/bash
# ============================================================
#   CYBERKIT v1.0 — All-in-One Cybersecurity Toolkit
#   Built by: ARUNACHALAM (gojosaturo)
#   GitHub  : https://github.com/Arunachalam-gojosaturo
#   OS      : Ubuntu / Debian / Kali / Parrot / Fedora / Arch
#   License : MIT 2026
# ============================================================

# ─── COLORS ────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
WHITE='\033[1;37m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# ─── GLOBALS ───────────────────────────────────────────────
LOG_FILE="$HOME/cyberkit_install.log"
TOOLS_DIR="$HOME/cyberkit-tools"
SCRIPT_VERSION="1.0"

# ============================================================
# SECTION 0 — BANNER
# ============================================================
banner() {
  clear
  echo -e "${CYAN}"
  echo "  ██████╗██╗   ██╗██████╗ ███████╗██████╗ ██╗  ██╗██╗████████╗"
  echo " ██╔════╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██║ ██╔╝██║╚══██╔══╝"
  echo " ██║      ╚████╔╝ ██████╔╝█████╗  ██████╔╝█████╔╝ ██║   ██║   "
  echo " ██║       ╚██╔╝  ██╔══██╗██╔══╝  ██╔══██╗██╔═██╗ ██║   ██║   "
  echo " ╚██████╗   ██║   ██████╔╝███████╗██║  ██║██║  ██╗██║   ██║   "
  echo "  ╚═════╝   ╚═╝   ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝   ╚═╝   "
  echo -e "${RESET}"
  echo -e "${DIM}  v${SCRIPT_VERSION} | All-in-One Cybersecurity Toolkit | by Arunachalam${RESET}"
  echo -e "${DIM}  ─────────────────────────────────────────────────────────${RESET}"
  echo ""
}

# ─── LOGGING ───────────────────────────────────────────────
log()     { echo -e "${DIM}[LOG]${RESET} $1" | tee -a "$LOG_FILE"; }
success() { echo -e "${GREEN}[✓]${RESET} $1" | tee -a "$LOG_FILE"; }
warn()    { echo -e "${YELLOW}[!]${RESET} $1" | tee -a "$LOG_FILE"; }
error()   { echo -e "${RED}[✗]${RESET} $1" | tee -a "$LOG_FILE"; }
info()    { echo -e "${CYAN}[*]${RESET} $1"; }
section() { echo -e "\n${PURPLE}${BOLD}══ $1 ══${RESET}\n"; }

# ─── SPINNER ───────────────────────────────────────────────
spinner() {
  local pid=$1
  local msg=$2
  local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
  local i=0
  while kill -0 "$pid" 2>/dev/null; do
    i=$(( (i+1) % 10 ))
    printf "\r${CYAN}  ${spin:$i:1}${RESET}  ${msg}..."
    sleep 0.1
  done
  printf "\r${GREEN}  ✓${RESET}  ${msg} done\n"
}

# ============================================================
# SECTION 1 — ROOT CHECK
# ============================================================
check_root() {
  section "PRIVILEGE CHECK"
  if [[ "$EUID" -ne 0 ]]; then
    error "This script requires root privileges."
    echo -e "  Run with: ${YELLOW}sudo bash $0${RESET}"
    exit 1
  fi
  success "Running as root."
}

# ============================================================
# SECTION 2 — OS DETECTION
# ============================================================
detect_os() {
  section "OS DETECTION"

  if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    OS_NAME="$ID"
    OS_PRETTY="$PRETTY_NAME"
    OS_FAMILY=""

    case "$ID" in
      ubuntu|debian|kali|parrot|linuxmint|pop)
        OS_FAMILY="debian"
        PKG_INSTALL="apt-get install -y"
        PKG_UPDATE="apt-get update -qq"
        ;;
      fedora|rhel|centos|rocky|almalinux)
        OS_FAMILY="fedora"
        PKG_INSTALL="dnf install -y"
        PKG_UPDATE="dnf check-update -q || true"
        ;;
      arch|manjaro|endeavouros|garuda)
        OS_FAMILY="arch"
        PKG_INSTALL="pacman -S --noconfirm"
        PKG_UPDATE="pacman -Sy"
        ;;
      opensuse*|sles)
        OS_FAMILY="suse"
        PKG_INSTALL="zypper install -y"
        PKG_UPDATE="zypper refresh"
        ;;
      *)
        warn "Unknown OS: $ID. Attempting Debian-style fallback."
        OS_FAMILY="debian"
        PKG_INSTALL="apt-get install -y"
        PKG_UPDATE="apt-get update -qq"
        ;;
    esac

    success "Detected: ${WHITE}${OS_PRETTY}${RESET}"
    info "Package family: ${CYAN}${OS_FAMILY}${RESET}"
  else
    error "Cannot detect OS. /etc/os-release not found."
    exit 1
  fi
}

# ============================================================
# SECTION 3 — PREREQUISITES
# ============================================================
install_prerequisites() {
  section "INSTALLING PREREQUISITES"

  info "Updating package lists..."
  eval "$PKG_UPDATE" >> "$LOG_FILE" 2>&1
  success "Package lists updated."

  local BASE_PKGS=()

  case "$OS_FAMILY" in
    debian)
      BASE_PKGS=(
        curl wget git python3 python3-pip build-essential
        libssl-dev libffi-dev net-tools unzip tar
        software-properties-common apt-transport-https
        ruby ruby-dev golang-go cargo snapd
      )
      ;;
    fedora)
      BASE_PKGS=(
        curl wget git python3 python3-pip gcc gcc-c++ make
        openssl-devel libffi-devel net-tools unzip tar
        ruby ruby-devel golang cargo
      )
      ;;
    arch)
      BASE_PKGS=(
        curl wget git python python-pip base-devel
        openssl net-tools unzip ruby go rust
      )
      ;;
    suse)
      BASE_PKGS=(
        curl wget git python3 python3-pip gcc make
        libopenssl-devel libffi-devel net-tools unzip ruby go
      )
      ;;
  esac

  for pkg in "${BASE_PKGS[@]}"; do
    eval "$PKG_INSTALL $pkg" >> "$LOG_FILE" 2>&1 &
    spinner $! "Installing $pkg"
  done

  mkdir -p "$TOOLS_DIR"
  success "Prerequisites installed. Tools directory: ${CYAN}$TOOLS_DIR${RESET}"
}

# ============================================================
# SECTION 4 — TOOL INSTALLATION FUNCTIONS
# ============================================================

# ── Helper: check if command exists ────────────────────────
cmd_exists() { command -v "$1" &>/dev/null; }

# ── Helper: pip install ────────────────────────────────────
pip_install() {
  pip3 install "$1" --quiet >> "$LOG_FILE" 2>&1
}

# ── Helper: go install ─────────────────────────────────────
go_install() {
  go install "$1" >> "$LOG_FILE" 2>&1
}

# ─────────────────────────────────────────────────────────────
install_tools() {
  section "INSTALLING CYBERSECURITY TOOLS"

  # ── 1. NMAP ────────────────────────────────────────────────
  info "[01/22] Nmap — Network scanner"
  if ! cmd_exists nmap; then
    eval "$PKG_INSTALL nmap" >> "$LOG_FILE" 2>&1 && success "Nmap installed." || warn "Nmap install failed."
  else success "Nmap already installed."; fi

  # ── 2. MASSCAN ─────────────────────────────────────────────
  info "[02/22] Masscan — Mass IP port scanner"
  if ! cmd_exists masscan; then
    eval "$PKG_INSTALL masscan" >> "$LOG_FILE" 2>&1 && success "Masscan installed." || {
      cd /tmp && git clone https://github.com/robertdavidgraham/masscan >> "$LOG_FILE" 2>&1
      cd masscan && make >> "$LOG_FILE" 2>&1 && cp bin/masscan /usr/local/bin/ && success "Masscan built from source."
    }
  else success "Masscan already installed."; fi

  # ── 3. NIKTO ───────────────────────────────────────────────
  info "[03/22] Nikto — Web server vulnerability scanner"
  if ! cmd_exists nikto; then
    eval "$PKG_INSTALL nikto" >> "$LOG_FILE" 2>&1 && success "Nikto installed." || warn "Nikto install failed."
  else success "Nikto already installed."; fi

  # ── 4. SQLMAP ──────────────────────────────────────────────
  info "[04/22] SQLMap — SQL injection automation"
  if ! cmd_exists sqlmap; then
    eval "$PKG_INSTALL sqlmap" >> "$LOG_FILE" 2>&1 || {
      cd "$TOOLS_DIR" && git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git >> "$LOG_FILE" 2>&1
      ln -sf "$TOOLS_DIR/sqlmap/sqlmap.py" /usr/local/bin/sqlmap
    }
    success "SQLMap installed."
  else success "SQLMap already installed."; fi

  # ── 5. GOBUSTER ────────────────────────────────────────────
  info "[05/22] Gobuster — Directory/file brute forcer"
  if ! cmd_exists gobuster; then
    eval "$PKG_INSTALL gobuster" >> "$LOG_FILE" 2>&1 || {
      go_install "github.com/OJ/gobuster/v3@latest" && \
      cp "$HOME/go/bin/gobuster" /usr/local/bin/ 2>/dev/null
    }
    success "Gobuster installed."
  else success "Gobuster already installed."; fi

  # ── 6. DIRB ────────────────────────────────────────────────
  info "[06/22] Dirb — Web content scanner"
  if ! cmd_exists dirb; then
    eval "$PKG_INSTALL dirb" >> "$LOG_FILE" 2>&1 && success "Dirb installed." || warn "Dirb install failed."
  else success "Dirb already installed."; fi

  # ── 7. SUBFINDER ───────────────────────────────────────────
  info "[07/22] Subfinder — Subdomain discovery"
  if ! cmd_exists subfinder; then
    go_install "github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest" >> "$LOG_FILE" 2>&1
    cp "$HOME/go/bin/subfinder" /usr/local/bin/ 2>/dev/null && success "Subfinder installed." || warn "Subfinder install failed."
  else success "Subfinder already installed."; fi

  # ── 8. AMASS ───────────────────────────────────────────────
  info "[08/22] Amass — OSINT & subdomain enumeration"
  if ! cmd_exists amass; then
    eval "$PKG_INSTALL amass" >> "$LOG_FILE" 2>&1 || {
      go_install "github.com/owasp-amass/amass/v4/...@master" >> "$LOG_FILE" 2>&1
      cp "$HOME/go/bin/amass" /usr/local/bin/ 2>/dev/null
    }
    success "Amass installed."
  else success "Amass already installed."; fi

  # ── 9. HTTPX / HTTPROBE ────────────────────────────────────
  info "[09/22] Httprobe — HTTP probe for live hosts"
  if ! cmd_exists httprobe; then
    go_install "github.com/tomnomnom/httprobe@latest" >> "$LOG_FILE" 2>&1
    cp "$HOME/go/bin/httprobe" /usr/local/bin/ 2>/dev/null && success "Httprobe installed." || warn "Httprobe install failed."
  else success "Httprobe already installed."; fi

  # ── 10. DNSRECON ───────────────────────────────────────────
  info "[10/22] DNSrecon — DNS enumeration"
  if ! cmd_exists dnsrecon; then
    eval "$PKG_INSTALL dnsrecon" >> "$LOG_FILE" 2>&1 || pip_install dnsrecon
    success "DNSrecon installed."
  else success "DNSrecon already installed."; fi

  # ── 11. WPSCAN ─────────────────────────────────────────────
  info "[11/22] WPScan — WordPress vulnerability scanner"
  if ! cmd_exists wpscan; then
    gem install wpscan >> "$LOG_FILE" 2>&1 && success "WPScan installed." || warn "WPScan install failed. Ensure Ruby/gem is available."
  else success "WPScan already installed."; fi

  # ── 12. JOHN THE RIPPER ────────────────────────────────────
  info "[12/22] John the Ripper — Password cracker"
  if ! cmd_exists john; then
    eval "$PKG_INSTALL john" >> "$LOG_FILE" 2>&1 && success "John installed." || warn "John install failed."
  else success "John already installed."; fi

  # ── 13. HASHCAT ────────────────────────────────────────────
  info "[13/22] Hashcat — GPU password cracker"
  if ! cmd_exists hashcat; then
    eval "$PKG_INSTALL hashcat" >> "$LOG_FILE" 2>&1 && success "Hashcat installed." || warn "Hashcat install failed."
  else success "Hashcat already installed."; fi

  # ── 14. HYDRA ──────────────────────────────────────────────
  info "[14/22] Hydra — Network login brute forcer"
  if ! cmd_exists hydra; then
    eval "$PKG_INSTALL hydra" >> "$LOG_FILE" 2>&1 && success "Hydra installed." || warn "Hydra install failed."
  else success "Hydra already installed."; fi

  # ── 15. TSHARK / WIRESHARK ─────────────────────────────────
  info "[15/22] TShark — CLI packet analyzer (Wireshark)"
  if ! cmd_exists tshark; then
    eval "$PKG_INSTALL tshark" >> "$LOG_FILE" 2>&1 && success "TShark installed." || warn "TShark install failed."
  else success "TShark already installed."; fi

  # ── 16. CLAMAV ─────────────────────────────────────────────
  info "[16/22] ClamAV — Open-source antivirus / malware scanner"
  if ! cmd_exists clamscan; then
    eval "$PKG_INSTALL clamav clamav-daemon" >> "$LOG_FILE" 2>&1 && success "ClamAV installed." || warn "ClamAV install failed."
  else success "ClamAV already installed."; fi

  # ── 17. YARA ───────────────────────────────────────────────
  info "[17/22] Yara — Malware pattern matching"
  if ! cmd_exists yara; then
    eval "$PKG_INSTALL yara" >> "$LOG_FILE" 2>&1 || pip_install yara-python
    success "Yara installed."
  else success "Yara already installed."; fi

  # ── 18. STEGHIDE ───────────────────────────────────────────
  info "[18/22] Steghide — Steganography tool"
  if ! cmd_exists steghide; then
    eval "$PKG_INSTALL steghide" >> "$LOG_FILE" 2>&1 && success "Steghide installed." || warn "Steghide install failed."
  else success "Steghide already installed."; fi

  # ── 19. BINWALK ────────────────────────────────────────────
  info "[19/22] Binwalk — Firmware/binary analysis"
  if ! cmd_exists binwalk; then
    eval "$PKG_INSTALL binwalk" >> "$LOG_FILE" 2>&1 || pip_install binwalk
    success "Binwalk installed."
  else success "Binwalk already installed."; fi

  # ── 20. NETCAT ─────────────────────────────────────────────
  info "[20/22] Netcat — Network swiss army knife"
  if ! cmd_exists nc; then
    eval "$PKG_INSTALL netcat-openbsd" >> "$LOG_FILE" 2>&1 || eval "$PKG_INSTALL ncat" >> "$LOG_FILE" 2>&1
    success "Netcat installed."
  else success "Netcat already installed."; fi

  # ── 21. NUCLEI ─────────────────────────────────────────────
  info "[21/22] Nuclei — Fast vulnerability scanner (templates)"
  if ! cmd_exists nuclei; then
    go_install "github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest" >> "$LOG_FILE" 2>&1
    cp "$HOME/go/bin/nuclei" /usr/local/bin/ 2>/dev/null && success "Nuclei installed." || warn "Nuclei install failed."
  else success "Nuclei already installed."; fi

  # ── 22. METASPLOIT ─────────────────────────────────────────
  info "[22/22] Metasploit Framework — Exploitation framework"
  if ! cmd_exists msfconsole; then
    warn "Metasploit not found. Installing via installer script..."
    curl -s https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb \
      > /tmp/msfinstall 2>/dev/null \
      && chmod +x /tmp/msfinstall \
      && /tmp/msfinstall >> "$LOG_FILE" 2>&1 \
      && success "Metasploit installed." \
      || warn "Metasploit install failed. Install manually: https://docs.metasploit.com"
  else success "Metasploit already installed."; fi

  section "ALL TOOLS PROCESSED"
  info "Installation log saved to: ${CYAN}$LOG_FILE${RESET}"
}

# ============================================================
# SECTION 5 — TOOL CHECKER (show installed/missing)
# ============================================================
check_tools() {
  section "TOOL STATUS CHECK"
  local tools=(
    nmap masscan nikto sqlmap gobuster dirb
    subfinder amass httprobe dnsrecon wpscan
    john hashcat hydra tshark clamscan yara
    steghide binwalk nc nuclei msfconsole
  )
  local installed=0
  local missing=0

  printf "  %-20s %s\n" "TOOL" "STATUS"
  printf "  %-20s %s\n" "────────────────────" "─────────"
  for tool in "${tools[@]}"; do
    if cmd_exists "$tool"; then
      printf "  ${GREEN}%-20s ✓ INSTALLED${RESET}\n" "$tool"
      ((installed++))
    else
      printf "  ${RED}%-20s ✗ MISSING${RESET}\n" "$tool"
      ((missing++))
    fi
  done
  echo ""
  echo -e "  ${GREEN}Installed: $installed${RESET}  |  ${RED}Missing: $missing${RESET}"
}

# ============================================================
# SECTION 6 — ABOUT
# ============================================================
about() {
  clear
  banner
  section "ABOUT THE CREATOR"
  echo -e "  ${WHITE}${BOLD}ARUNACHALAM${RESET}"
  echo -e "  ${DIM}alias: gojosaturo${RESET}"
  echo ""
  echo -e "  ${CYAN}Location  :${RESET} Vellore, Tamil Nadu 🇮🇳"
  echo -e "  ${CYAN}OS        :${RESET} Arch Linux + Hyprland (Wayland)"
  echo -e "  ${CYAN}Shell     :${RESET} Zsh + custom dotfiles"
  echo -e "  ${CYAN}Editor    :${RESET} Neovim / VS Code"
  echo -e "  ${CYAN}Peak Hours:${RESET} 02:00 – 04:00 🌙"
  echo ""
  echo -e "  ${PURPLE}Skills    :${RESET} Linux · Bash · Python · Node.js · React · TypeScript"
  echo -e "             Android GSI · Cybersecurity · AI Integration"
  echo ""
  echo -e "  ${YELLOW}Projects  :${RESET}"
  echo -e "    🌙 Luna AI       — WhatsApp AI agent (Groq + Edge TTS)"
  echo -e "    🔴 ARC-Network   — Full-stack cybersecurity web hub"
  echo -e "    🟡 Job Hunter v3 — Autonomous job scanning agent"
  echo -e "    🐧 Hyprland Dots — Iron Man arc-reactor themed Arch setup"
  echo -e "    📱 Android GSI   — Custom AOSP system image builder"
  echo ""
  echo -e "  ${GREEN}GitHub    :${RESET} https://github.com/Arunachalam-gojosaturo"
  echo -e "  ${GREEN}Instagram :${RESET} https://instagram.com/saturogojo_ac"
  echo ""
  echo -e "  ${DIM}\"If I decide to do something, I complete it — no matter what.\"${RESET}"
  echo ""
  read -rp "  Press Enter to return to menu..." _
}

# ============================================================
# SECTION 7 — TOOL LAUNCHERS
# ============================================================

run_nmap() {
  read -rp "  Enter target IP/hostname: " TARGET
  read -rp "  Scan type [1=Quick, 2=Full, 3=Stealth, 4=OS Detect]: " SCAN_TYPE
  case "$SCAN_TYPE" in
    1) nmap -T4 -F "$TARGET" ;;
    2) nmap -T4 -A -v "$TARGET" ;;
    3) nmap -sS -T2 "$TARGET" ;;
    4) nmap -O "$TARGET" ;;
    *) nmap "$TARGET" ;;
  esac
}

run_nikto() {
  read -rp "  Enter target URL (e.g. http://example.com): " TARGET
  nikto -h "$TARGET"
}

run_sqlmap() {
  read -rp "  Enter target URL (with ?param=value): " TARGET
  sqlmap -u "$TARGET" --batch --dbs
}

run_gobuster() {
  read -rp "  Enter target URL: " TARGET
  read -rp "  Wordlist path [default: /usr/share/wordlists/dirb/common.txt]: " WL
  WL="${WL:-/usr/share/wordlists/dirb/common.txt}"
  gobuster dir -u "$TARGET" -w "$WL"
}

run_subfinder() {
  read -rp "  Enter domain (e.g. example.com): " DOMAIN
  subfinder -d "$DOMAIN"
}

run_wpscan() {
  read -rp "  Enter WordPress URL: " TARGET
  wpscan --url "$TARGET" --enumerate u
}

run_hydra() {
  read -rp "  Target IP: " TARGET
  read -rp "  Service (ssh/ftp/http-post-form/etc): " SERVICE
  read -rp "  Username or userlist: " USER
  read -rp "  Password list path: " PASSLIST
  hydra -l "$USER" -P "$PASSLIST" "$TARGET" "$SERVICE"
}

run_john() {
  read -rp "  Path to hash file: " HASHFILE
  read -rp "  Wordlist path [default: /usr/share/wordlists/rockyou.txt]: " WL
  WL="${WL:-/usr/share/wordlists/rockyou.txt}"
  john "$HASHFILE" --wordlist="$WL"
}

run_clamav() {
  read -rp "  Path to scan [default: $HOME]: " SCAN_PATH
  SCAN_PATH="${SCAN_PATH:-$HOME}"
  info "Updating ClamAV database first..."
  freshclam 2>/dev/null || warn "freshclam failed — continuing with existing DB."
  clamscan -r "$SCAN_PATH" --bell -i
}

run_tshark() {
  read -rp "  Interface [default: eth0]: " IFACE
  IFACE="${IFACE:-eth0}"
  read -rp "  Capture duration in seconds [default: 30]: " DURATION
  DURATION="${DURATION:-30}"
  tshark -i "$IFACE" -a duration:"$DURATION"
}

run_nuclei() {
  read -rp "  Enter target URL: " TARGET
  nuclei -u "$TARGET" -severity medium,high,critical
}

run_masscan() {
  read -rp "  Target IP or CIDR (e.g. 192.168.1.0/24): " TARGET
  read -rp "  Port range [default: 1-1000]: " PORTS
  PORTS="${PORTS:-1-1000}"
  masscan "$TARGET" -p"$PORTS" --rate=1000
}

run_steghide() {
  echo -e "  ${CYAN}Steghide options:${RESET}"
  echo "  [1] Embed file into image"
  echo "  [2] Extract file from image"
  read -rp "  Choice: " CHOICE
  case "$CHOICE" in
    1)
      read -rp "  Cover file (image): " COVER
      read -rp "  Secret file to embed: " SECRET
      steghide embed -cf "$COVER" -ef "$SECRET"
      ;;
    2)
      read -rp "  Stego file: " STEGO
      steghide extract -sf "$STEGO"
      ;;
  esac
}

run_binwalk() {
  read -rp "  Path to binary/firmware file: " BINFILE
  binwalk -e "$BINFILE"
}

run_dnsrecon() {
  read -rp "  Target domain: " DOMAIN
  dnsrecon -d "$DOMAIN"
}

run_metasploit() {
  if cmd_exists msfconsole; then
    warn "Launching Metasploit Framework console..."
    msfconsole
  else
    error "Metasploit not installed. Run option [I] to install tools."
  fi
}

# ============================================================
# SECTION 8 — UPDATE TOOLS
# ============================================================
update_tools() {
  section "UPDATING TOOLS"
  info "Updating system packages..."
  eval "$PKG_UPDATE" >> "$LOG_FILE" 2>&1

  local tools_to_update=(nmap nikto sqlmap john hashcat hydra tshark clamav yara steghide dirb binwalk)
  for t in "${tools_to_update[@]}"; do
    eval "$PKG_INSTALL $t" >> "$LOG_FILE" 2>&1 &
    spinner $! "Updating $t"
  done

  if cmd_exists nuclei; then
    info "Updating Nuclei templates..."
    nuclei -update-templates >> "$LOG_FILE" 2>&1 && success "Nuclei templates updated."
  fi

  if cmd_exists wpscan; then
    info "Updating WPScan database..."
    wpscan --update >> "$LOG_FILE" 2>&1 && success "WPScan updated."
  fi

  success "Update complete."
  read -rp "  Press Enter to return to menu..." _
}

# ============================================================
# SECTION 9 — MAIN MENU
# ============================================================
main_menu() {
  while true; do
    banner
    echo -e "  ${BOLD}${CYAN}[ MAIN MENU ]${RESET}\n"
    echo -e "  ${YELLOW}─── SETUP ──────────────────────────────────${RESET}"
    echo -e "  ${WHITE}[I]${RESET} Install All Tools"
    echo -e "  ${WHITE}[U]${RESET} Update All Tools"
    echo -e "  ${WHITE}[C]${RESET} Check Tool Status"
    echo ""
    echo -e "  ${YELLOW}─── NETWORK RECON ──────────────────────────${RESET}"
    echo -e "  ${WHITE}[1]${RESET}  Nmap          — Network Scanner"
    echo -e "  ${WHITE}[2]${RESET}  Masscan       — Mass Port Scanner"
    echo -e "  ${WHITE}[3]${RESET}  Subfinder     — Subdomain Discovery"
    echo -e "  ${WHITE}[4]${RESET}  DNSrecon      — DNS Enumeration"
    echo ""
    echo -e "  ${YELLOW}─── WEB SECURITY ───────────────────────────${RESET}"
    echo -e "  ${WHITE}[5]${RESET}  Nikto         — Web Vulnerability Scan"
    echo -e "  ${WHITE}[6]${RESET}  SQLMap        — SQL Injection"
    echo -e "  ${WHITE}[7]${RESET}  Gobuster      — Directory Brute Force"
    echo -e "  ${WHITE}[8]${RESET}  WPScan        — WordPress Scanner"
    echo -e "  ${WHITE}[9]${RESET}  Nuclei        — Template-based Vuln Scan"
    echo ""
    echo -e "  ${YELLOW}─── PASSWORD ATTACKS ───────────────────────${RESET}"
    echo -e "  ${WHITE}[10]${RESET} Hydra         — Login Brute Forcer"
    echo -e "  ${WHITE}[11]${RESET} John          — Password Cracker"
    echo ""
    echo -e "  ${YELLOW}─── FORENSICS & ANALYSIS ───────────────────${RESET}"
    echo -e "  ${WHITE}[12]${RESET} TShark        — Packet Capture / Analysis"
    echo -e "  ${WHITE}[13]${RESET} ClamAV        — Malware Scanner"
    echo -e "  ${WHITE}[14]${RESET} Steghide      — Steganography"
    echo -e "  ${WHITE}[15]${RESET} Binwalk       — Firmware/Binary Analysis"
    echo ""
    echo -e "  ${YELLOW}─── EXPLOITATION ───────────────────────────${RESET}"
    echo -e "  ${WHITE}[16]${RESET} Metasploit    — Exploitation Framework"
    echo ""
    echo -e "  ${YELLOW}─── INFO ────────────────────────────────────${RESET}"
    echo -e "  ${WHITE}[A]${RESET}  About Creator"
    echo -e "  ${WHITE}[L]${RESET}  View Install Log"
    echo -e "  ${WHITE}[Q]${RESET}  Quit"
    echo ""
    read -rp "  Enter choice: " CHOICE

    case "${CHOICE^^}" in
      I) install_prerequisites; install_tools; read -rp "  Press Enter..." _ ;;
      U) update_tools ;;
      C) check_tools; read -rp "  Press Enter..." _ ;;
      1) run_nmap ;;
      2) run_masscan ;;
      3) run_subfinder ;;
      4) run_dnsrecon ;;
      5) run_nikto ;;
      6) run_sqlmap ;;
      7) run_gobuster ;;
      8) run_wpscan ;;
      9) run_nuclei ;;
      10) run_hydra ;;
      11) run_john ;;
      12) run_tshark ;;
      13) run_clamav ;;
      14) run_steghide ;;
      15) run_binwalk ;;
      16) run_metasploit ;;
      A) about ;;
      L) less "$LOG_FILE" ;;
      Q)
        echo -e "\n  ${CYAN}Goodbye. Stay curious. Stay ethical.${RESET}\n"
        exit 0
        ;;
      *)
        warn "Invalid choice: '$CHOICE'. Try again."
        sleep 1
        ;;
    esac
  done
}

# ============================================================
# ENTRY POINT
# ============================================================
main() {
  # Init log
  echo "# CyberKit v${SCRIPT_VERSION} — Log started $(date)" > "$LOG_FILE"

  check_root
  detect_os

  # First-run: ask to install
  banner
  echo -e "  ${YELLOW}First time? Run [I] from the menu to install all tools.${RESET}"
  echo -e "  ${DIM}Log file: $LOG_FILE${RESET}"
  sleep 2

  main_menu
}

main "$@"
