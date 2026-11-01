#!/usr/bin/env bash
# ==============================================================================
# Pars Linux - Geliştirici Modülü (pars-dev)
# Bileşenler: Git, VS Codium, Docker, DBeaver
# ==============================================================================

ROLE_DEV_NAME="pars-dev"
ROLE_DEV_DESC="Git & LFS, VS Codium, Docker & Compose, DBeaver Universal DB"

# Alt bileşenler listesi: ID:Ad:VarsayılanSeçili (1/0)
DEV_COMPONENTS=(
    "git:Git & Git-LFS Versiyon Kontrolü:1"
    "codium:VSCodium Açık Kaynak Kod Editörü:1"
    "docker:Docker Engine & Docker Compose:1"
    "dbeaver:DBeaver Veritabanı Yöneticisi:1"
)

install_dev_git() {
    log_info "Git ve Git-LFS kuruluyor..."
    pkg_install "git" ""
    pkg_install "git-lfs" ""
    git lfs install --skip-repo 2>/dev/null || true
    log_success "Git & Git-LFS hazırlandı."
}

install_dev_codium() {
    log_info "VS Codium kuruluyor..."
    local pm
    pm="$(detect_package_manager)"
    case "${pm}" in
        pacman) pkg_install "vscodium-bin" "com.vscodium.codium" ;;
        apt)    pkg_install "codium" "com.vscodium.codium" ;;
        *)      pkg_install "codium" "com.vscodium.codium" ;;
    esac
}

install_dev_docker() {
    log_info "Docker ve Docker Compose kuruluyor..."
    local pm
    pm="$(detect_package_manager)"

    case "${pm}" in
        pacman)
            pkg_install "docker" ""
            pkg_install "docker-compose" ""
            ;;
        apt)
            pkg_install "docker.io" ""
            pkg_install "docker-compose-plugin" ""
            ;;
        *)
            pkg_install "docker" ""
            pkg_install "docker-compose" ""
            ;;
    esac

    check_sudo
    # Servisi başlat ve etkinleştir
    ${SUDO_CMD} systemctl enable --now docker.service 2>/dev/null || true

    # Kullanıcıyı docker grubuna ekle
    local current_user="${SUDO_USER:-$USER}"
    if [[ -n "${current_user}" && "${current_user}" != "root" ]]; then
        ${SUDO_CMD} usermod -aG docker "${current_user}" 2>/dev/null || true
        log_info "Kullanıcı '${current_user}' docker grubuna eklendi."
    fi

    log_success "Docker servisi yapılandırıldı."
}

install_dev_dbeaver() {
    log_info "DBeaver Universal Database Manager kuruluyor..."
    pkg_install "dbeaver" "io.dbeaver.DBeaverCommunity"
}

install_dev_all() {
    log_header "pars-dev Rolü Kurulumu Başlatılıyor"
    install_dev_git
    install_dev_codium
    install_dev_docker
    install_dev_dbeaver
    log_success "pars-dev kurulumu tamamlandı!"
}
