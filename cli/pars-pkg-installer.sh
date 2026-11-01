#!/usr/bin/env bash
# ==============================================================================
# Pars Linux - Modüler Ek Paket Rolleri Yükleyicisi (CLI & TUI)
# Desteklenen Roller:
#   - pars-gaming  (Steam, Lutris, Heroic, GameMode, MangoHud)
#   - pars-dev     (Git, VS Codium, Docker, DBeaver)
#   - pars-creator (OBS Studio, GIMP, Inkscape, Kdenlive, Audacity)
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/modules/common.sh"
source "${SCRIPT_DIR}/modules/gaming.sh"
source "${SCRIPT_DIR}/modules/dev.sh"
source "${SCRIPT_DIR}/modules/creator.sh"

show_banner() {
    cat << "EOF"
  ____                     _     _                  
 |  _ \ __ _ _ __ ___     | |   (_)_ __  _   ___  __
 | |_) / _` | '__/ __|____| |   | | '_ \| | | \ \/ /
 |  __/ (_| | |  \__ \____| |___| | | | | |_| |>  < 
 |_|   \__,_|_|  |___/    |_____|_|_| |_|\__,_/_/\_\
   Pars Linux - Modüler Ek Paket Rolleri Yükleyicisi
EOF
    echo ""
}

show_help() {
    show_banner
    echo -e "${CLR_BOLD}Kullanım:${CLR_RESET} $0 [SEÇENEKLER]"
    echo ""
    echo -e "${CLR_BOLD}Seçenekler:${CLR_RESET}"
    echo "  -h, --help                 Bu yardım mesajını gösterir"
    echo "  -l, --list                 Mevcut rolleri ve granüler alt modülleri listeler"
    echo "  -r, --role <ROL_ADI>       Belirtilen rolün tüm bileşenlerini kurar"
    echo "                             (gaming, dev, creator veya all)"
    echo "  -m, --modules <m1,m2,...>  Virgülle ayrılmış modülleri kurar"
    echo "                             (örn: steam,codium,docker,obs)"
    echo "  -p, --profile <DOSYA>      Belirtilen profil dosyasını (.conf) okuyarak kurar"
    echo "  -i, --interactive          İnteraktif TUI / Seçim menüsünü başlatır"
    echo ""
    echo -e "${CLR_BOLD}Örnekler:${CLR_RESET}"
    echo "  $0 --role gaming"
    echo "  $0 --modules steam,lutris,docker,codium"
    echo "  $0 --profile profiles/dev.conf"
    echo "  $0 --interactive"
    echo ""
}

list_all_modules() {
    show_banner
    log_header "Mevcut Ek Paket Rolleri ve Modülleri"
    echo ""
    echo -e "${CLR_YELLOW}${CLR_BOLD}[1] ${ROLE_GAMING_NAME}${CLR_RESET} - ${ROLE_GAMING_DESC}"
    for comp in "${GAMING_COMPONENTS[@]}"; do
        IFS=":" read -r id name _ <<< "${comp}"
        echo -e "    ├── \e[36m${id}\e[0m: ${name}"
    done
    echo ""
    echo -e "${CLR_YELLOW}${CLR_BOLD}[2] ${ROLE_DEV_NAME}${CLR_RESET} - ${ROLE_DEV_DESC}"
    for comp in "${DEV_COMPONENTS[@]}"; do
        IFS=":" read -r id name _ <<< "${comp}"
        echo -e "    ├── \e[36m${id}\e[0m: ${name}"
    done
    echo ""
    echo -e "${CLR_YELLOW}${CLR_BOLD}[3] ${ROLE_CREATOR_NAME}${CLR_RESET} - ${ROLE_CREATOR_DESC}"
    for comp in "${CREATOR_COMPONENTS[@]}"; do
        IFS=":" read -r id name _ <<< "${comp}"
        echo -e "    ├── \e[36m${id}\e[0m: ${name}"
    done
    echo ""
}

install_by_id() {
    local comp_id="$1"
    case "${comp_id}" in
        # Gaming
        steam)    install_gaming_steam ;;
        lutris)   install_gaming_lutris ;;
        heroic)   install_gaming_heroic ;;
        gamemode) install_gaming_gamemode ;;
        mangohud) install_gaming_mangohud ;;
        gaming)   install_gaming_all ;;

        # Dev
        git)      install_dev_git ;;
        codium)   install_dev_codium ;;
        docker)   install_dev_docker ;;
        dbeaver)  install_dev_dbeaver ;;
        dev)      install_dev_all ;;

        # Creator
        obs)      install_creator_obs ;;
        gimp)     install_creator_gimp ;;
        inkscape) install_creator_inkscape ;;
        kdenlive) install_creator_kdenlive ;;
        audacity) install_creator_audacity ;;
        creator)  install_creator_all ;;

        *)
            log_warn "Bilinmeyen modül: '${comp_id}', atlanıyor."
            ;;
    esac
}

install_multiple_modules() {
    local list_str="$1"
    IFS=',' read -ra ITEMS <<< "${list_str}"
    for item in "${ITEMS[@]}"; do
        item="$(echo "${item}" | xargs)"
        if [[ -n "${item}" ]]; then
            install_by_id "${item}"
        fi
    done
}

run_from_profile() {
    local prof_file="$1"
    if [[ ! -f "${prof_file}" ]]; then
        log_error "Profil dosyası bulunamadı: ${prof_file}"
        exit 1
    fi

    log_info "Profil yükleniyor: ${prof_file}"
    # shellcheck disable=SC1090
    source "${prof_file}"

    # Gaming
    [[ "${ENABLE_STEAM:-0}" == "1" ]] && install_gaming_steam
    [[ "${ENABLE_LUTRIS:-0}" == "1" ]] && install_gaming_lutris
    [[ "${ENABLE_HEROIC:-0}" == "1" ]] && install_gaming_heroic
    [[ "${ENABLE_GAMEMODE:-0}" == "1" ]] && install_gaming_gamemode
    [[ "${ENABLE_MANGOHUD:-0}" == "1" ]] && install_gaming_mangohud

    # Dev
    [[ "${ENABLE_GIT:-0}" == "1" ]] && install_dev_git
    [[ "${ENABLE_CODIUM:-0}" == "1" ]] && install_dev_codium
    [[ "${ENABLE_DOCKER:-0}" == "1" ]] && install_dev_docker
    [[ "${ENABLE_DBEAVER:-0}" == "1" ]] && install_dev_dbeaver

    # Creator
    [[ "${ENABLE_OBS:-0}" == "1" ]] && install_creator_obs
    [[ "${ENABLE_GIMP:-0}" == "1" ]] && install_creator_gimp
    [[ "${ENABLE_INKSCAPE:-0}" == "1" ]] && install_creator_inkscape
    [[ "${ENABLE_KDENLIVE:-0}" == "1" ]] && install_creator_kdenlive
    [[ "${ENABLE_AUDACITY:-0}" == "1" ]] && install_creator_audacity

    log_success "Profildeki tüm seçili modüller kuruldu."
}

# TUI Arayüzü (whiptail veya dialog ile checklist)
run_tui() {
    local ui_tool=""
    if command -v whiptail >/dev/null 2>&1; then
        ui_tool="whiptail"
    elif command -v dialog >/dev/null 2>&1; then
        ui_tool="dialog"
    fi

    if [[ -n "${ui_tool}" ]]; then
        local checklist_args=(
            "Pars Linux Ek Paket Rolleri"
            "Kurmak istediğiniz granüler modülleri Space (Boşluk) tuşu ile seçin:"
            22 76 14
        )

        # Gaming
        for c in "${GAMING_COMPONENTS[@]}"; do
            IFS=":" read -r id name def <<< "${c}"
            checklist_args+=("${id}" "[Gaming] ${name}" "$([ "${def}" == "1" ] && echo "ON" || echo "OFF")")
        done

        # Dev
        for c in "${DEV_COMPONENTS[@]}"; do
            IFS=":" read -r id name def <<< "${c}"
            checklist_args+=("${id}" "[Dev] ${name}" "$([ "${def}" == "1" ] && echo "ON" || echo "OFF")")
        done

        # Creator
        for c in "${CREATOR_COMPONENTS[@]}"; do
            IFS=":" read -r id name def <<< "${c}"
            checklist_args+=("${id}" "[Creator] ${name}" "$([ "${def}" == "1" ] && echo "ON" || echo "OFF")")
        done

        local choices
        if choices=$("${ui_tool}" --title "Pars Linux - Modüler Paket Seçimi" --checklist "${checklist_args[@]}" 3>&1 1>&2 2>&3); then
            clear
            show_banner
            log_info "Seçilen modüller kuruluyor: ${choices}"
            # Tırnakları temizle
            choices="$(echo "${choices}" | tr -d '"')"
            for ch in ${choices}; do
                install_by_id "${ch}"
            done
            log_success "Tüm seçilen bileşenlerin kurulumu tamamlandı!"
        else
            echo "Kurulum iptal edildi."
            exit 0
        fi
    else
        # Fallback ANSI Konsol Menüsü
        run_console_menu
    fi
}

run_console_menu() {
    show_banner
    log_header "İnteraktif Konsol Modu"
    echo "Hangi rolü veya modülleri kurmak istiyorsunuz?"
    echo "1) Tüm Oyun Rolünü Kur (pars-gaming: Steam, Lutris, Heroic, GameMode, MangoHud)"
    echo "2) Tüm Geliştirici Rolünü Kur (pars-dev: Git, VS Codium, Docker, DBeaver)"
    echo "3) Tüm İçerik Üretici Rolünü Kur (pars-creator: OBS, GIMP, Inkscape, Kdenlive, Audacity)"
    echo "4) Tüm Rolleri Eksiksiz Kur (Tam Kurulum)"
    echo "5) Özel Granüler Seçim Yap (Virgülle modül kodları gir)"
    echo "0) Çıkış"
    echo ""
    read -rp "Seçiminiz [0-5]: " choice
    case "${choice}" in
        1) install_gaming_all ;;
        2) install_dev_all ;;
        3) install_creator_all ;;
        4)
            install_gaming_all
            install_dev_all
            install_creator_all
            ;;
        5)
            echo "Örnek modüller: steam, lutris, heroic, gamemode, mangohud, git, codium, docker, dbeaver, obs, gimp, inkscape, kdenlive, audacity"
            read -rp "Kurulacak modülleri girin: " custom_mods
            install_multiple_modules "${custom_mods}"
            ;;
        0) echo "Çıkış yapıldı."; exit 0 ;;
        *) log_error "Geçersiz seçim!"; exit 1 ;;
    esac
}

# Parametre Yönetimi
if [[ $# -eq 0 ]]; then
    run_tui
    exit 0
fi

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -l|--list)
            list_all_modules
            exit 0
            ;;
        -r|--role)
            shift
            target_role="${1:-}"
            case "${target_role}" in
                gaming)  install_gaming_all ;;
                dev)     install_dev_all ;;
                creator) install_creator_all ;;
                all)
                    install_gaming_all
                    install_dev_all
                    install_creator_all
                    ;;
                *)
                    log_error "Bilinmeyen rol: '${target_role}'. Geçerli roller: gaming, dev, creator, all"
                    exit 1
                    ;;
            esac
            shift
            ;;
        -m|--modules)
            shift
            install_multiple_modules "${1:-}"
            shift
            ;;
        -p|--profile)
            shift
            run_from_profile "${1:-}"
            shift
            ;;
        -i|--interactive)
            run_tui
            exit 0
            ;;
        *)
            log_error "Bilinmeyen parametre: $1"
            show_help
            exit 1
            ;;
    esac
done
