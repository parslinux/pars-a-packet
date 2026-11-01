#!/usr/bin/env bash
# ==============================================================================
# Pars Linux - Modüler Paket Yükleyici Ortak Yardımcı Fonksiyonlar
# ==============================================================================

# Renkler
CLR_RESET="\e[0m"
CLR_BOLD="\e[1m"
CLR_RED="\e[1;31m"
CLR_GREEN="\e[1;32m"
CLR_YELLOW="\e[1;33m"
CLR_BLUE="\e[1;34m"
CLR_CYAN="\e[1;36m"
CLR_MAGENTA="\e[1;35m"

log_info() {
    echo -e "${CLR_BLUE}[BİLGİ]${CLR_RESET} $*"
}

log_success() {
    echo -e "${CLR_GREEN}[BAŞARILI]${CLR_RESET} $*"
}

log_warn() {
    echo -e "${CLR_YELLOW}[UYARI]${CLR_RESET} $*"
}

log_error() {
    echo -e "${CLR_RED}[HATA]${CLR_RESET} $*" >&2
}

log_header() {
    echo -e "${CLR_CYAN}${CLR_BOLD}=== $* ===${CLR_RESET}"
}

# Dağıtım ve Paket Yöneticisi Tespiti
detect_package_manager() {
    if command -v pacman >/dev/null 2>&1; then
        echo "pacman"
    elif command -v apt-get >/dev/null 2>&1; then
        echo "apt"
    elif command -v dnf >/dev/null 2>&1; then
        echo "dnf"
    elif command -v zypper >/dev/null 2>&1; then
        echo "zypper"
    else
        echo "unknown"
    fi
}

check_sudo() {
    if [[ $EUID -ne 0 ]]; then
        if command -v sudo >/dev/null 2>&1; then
            SUDO_CMD="sudo"
        else
            log_error "Bu işlem için root veya sudo yetkisi gerekmektedir."
            return 1
        fi
    else
        SUDO_CMD=""
    fi
}

# Flatpak varlığını doğrula veya öner
ensure_flatpak() {
    if command -v flatpak >/dev/null 2>&1; then
        # Flathub deposu ekli mi kontrol et
        if ! flatpak remote-list | grep -q "flathub"; then
            log_info "Flathub deposu yapılandırılıyor..."
            ${SUDO_CMD} flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || true
        fi
        return 0
    fi
    log_warn "Flatpak yüklü değil. Bazı ek uygulamalar için Flatpak önerilir."
    return 1
}

# Evrensel paket kurucu
pkg_install() {
    local native_pkg="$1"
    local flatpak_id="${2:-}"
    local pm
    pm="$(detect_package_manager)"

    check_sudo

    log_info "Yükleniyor: ${native_pkg} (${pm})..."

    case "${pm}" in
        pacman)
            if ${SUDO_CMD} pacman -S --noconfirm --needed "${native_pkg}" 2>/dev/null; then
                log_success "${native_pkg} başarıyla kuruldu."
                return 0
            elif command -v yay >/dev/null 2>&1 && yay -S --noconfirm --needed "${native_pkg}" 2>/dev/null; then
                log_success "${native_pkg} (AUR) kuruldu."
                return 0
            elif command -v paru >/dev/null 2>&1 && paru -S --noconfirm --needed "${native_pkg}" 2>/dev/null; then
                log_success "${native_pkg} (AUR) kuruldu."
                return 0
            fi
            ;;
        apt)
            if ${SUDO_CMD} apt-get install -y "${native_pkg}" 2>/dev/null; then
                log_success "${native_pkg} başarıyla kuruldu."
                return 0
            fi
            ;;
        dnf)
            if ${SUDO_CMD} dnf install -y "${native_pkg}" 2>/dev/null; then
                log_success "${native_pkg} başarıyla kuruldu."
                return 0
            fi
            ;;
        zypper)
            if ${SUDO_CMD} zypper install -y "${native_pkg}" 2>/dev/null; then
                log_success "${native_pkg} başarıyla kuruldu."
                return 0
            fi
            ;;
    esac

    # Eğer yerel depoda bulunamadıysa ve flatpak kimliği verilmişse
    if [[ -n "${flatpak_id}" ]]; then
        log_warn "${native_pkg} yerel depoda bulunamadı. Flatpak deneniyor (${flatpak_id})..."
        if ensure_flatpak; then
            if flatpak install -y flathub "${flatpak_id}"; then
                log_success "${native_pkg} (${flatpak_id}) Flatpak üzerinden kuruldu."
                return 0
            fi
        fi
    fi

    log_error "${native_pkg} paketi kurulamadı."
    return 1
}
