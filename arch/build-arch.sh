#!/usr/bin/env bash
# ==============================================================================
# Pars Linux - Arch Linux Split Meta Paket Derleme / Denetleme Scripti
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${SCRIPT_DIR}/dist"

mkdir -p "${OUTPUT_DIR}"

log_info() {
    echo -e "\e[1;34m[BİLGİ]\e[0m $*"
}

log_success() {
    echo -e "\e[1;32m[BAŞARILI]\e[0m $*"
}

log_error() {
    echo -e "\e[1;31m[HATA]\e[0m $*" >&2
}

build_arch_role() {
    local role_dir="$1"
    local role_name
    role_name="$(basename "${role_dir}")"

    log_info "Arch PKGBUILD derleniyor: ${role_name}..."

    (
        cd "${role_dir}"
        # .SRCINFO güncelle
        makepkg --printsrcinfo > .SRCINFO 2>/dev/null || true
        # Bağımlılıkları sistemden çekmeyi zorlamadan paket arşivini oluştur
        PKGDEST="${OUTPUT_DIR}" makepkg -f -d --nodeps --cleanbuild
    )

    log_success "${role_name} Arch paketleri hazırlandı -> ${OUTPUT_DIR}"
}

if ! command -v makepkg >/dev/null 2>&1; then
    log_error "makepkg komutu bulunamadı. Lütfen pacman/base-devel paketlerini yükleyin."
    exit 1
fi

for rdir in "${SCRIPT_DIR}"/pars-*; do
    if [[ -d "${rdir}" && -f "${rdir}/PKGBUILD" ]]; then
        build_arch_role "${rdir}"
    fi
done

echo ""
log_success "Tüm Arch (.pkg.tar.zst) paketleri başarıyla oluşturuldu! Çıktı: ${OUTPUT_DIR}"
