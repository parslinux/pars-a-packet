#!/usr/bin/env bash
# ==============================================================================
# Pars Linux - Debian Meta Paket Derleme Scripti
# dpkg-deb varsa onu kullanır; yoksa yerel 'ar' ve 'tar' ile derler.
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${SCRIPT_DIR}/dist"
BUILD_TEMP="${SCRIPT_DIR}/.tmp_build"

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

build_single_deb() {
    local control_file="$1"
    local pkg_name
    local pkg_version
    local pkg_arch

    pkg_name=$(grep "^Package:" "${control_file}" | awk '{print $2}')
    pkg_version=$(grep "^Version:" "${control_file}" | awk '{print $2}')
    pkg_arch=$(grep "^Architecture:" "${control_file}" | awk '{print $2}')

    if [[ -z "${pkg_name}" || -z "${pkg_version}" || -z "${pkg_arch}" ]]; then
        log_error "Geçersiz control dosyası: ${control_file}"
        return 1
    fi

    log_info "Paketleniyor: ${pkg_name} (${pkg_version}_${pkg_arch})"

    local pkg_dir="${BUILD_TEMP}/${pkg_name}_${pkg_version}_${pkg_arch}"
    rm -rf "${pkg_dir}"
    mkdir -p "${pkg_dir}/DEBIAN"
    mkdir -p "${pkg_dir}/usr/share/doc/${pkg_name}"

    # Control dosyasını kopyala
    cp "${control_file}" "${pkg_dir}/DEBIAN/control"
    echo "Pars Linux Metapackage: ${pkg_name}" > "${pkg_dir}/usr/share/doc/${pkg_name}/copyright"

    # Varsa postinst / prerm dosyalarını da ekle
    local postinst="${control_file%.control}.postinst"
    if [[ -f "${postinst}" ]]; then
        cp "${postinst}" "${pkg_dir}/DEBIAN/postinst"
        chmod 755 "${pkg_dir}/DEBIAN/postinst"
    fi

    local prerm="${control_file%.control}.prerm"
    if [[ -f "${prerm}" ]]; then
        cp "${prerm}" "${pkg_dir}/DEBIAN/prerm"
        chmod 755 "${pkg_dir}/DEBIAN/prerm"
    fi

    local deb_output="${OUTPUT_DIR}/${pkg_name}_${pkg_version}_${pkg_arch}.deb"

    if command -v dpkg-deb >/dev/null 2>&1; then
        dpkg-deb --build --root-owner-group "${pkg_dir}" "${deb_output}" >/dev/null
    else
        # Fallback: ar ve tar ile saf .deb paketleme
        local pack_temp="${BUILD_TEMP}/pack_${pkg_name}"
        rm -rf "${pack_temp}"
        mkdir -p "${pack_temp}"

        echo "2.0" > "${pack_temp}/debian-binary"

        # control.tar.gz
        (cd "${pkg_dir}/DEBIAN" && tar --owner=0 --group=0 -czf "${pack_temp}/control.tar.gz" ./*)

        # data.tar.gz
        (cd "${pkg_dir}" && tar --owner=0 --group=0 -czf "${pack_temp}/data.tar.gz" --exclude='./DEBIAN' usr)

        # deb arşivini oluştur
        (cd "${pack_temp}" && ar -rcs "${deb_output}" debian-binary control.tar.gz data.tar.gz)
        rm -rf "${pack_temp}"
    fi

    log_success "Oluşturuldu: ${deb_output}"
}

build_all() {
    rm -rf "${BUILD_TEMP}"
    mkdir -p "${BUILD_TEMP}"

    log_info "Debian meta paketleri derleniyor..."

    find "${SCRIPT_DIR}" -type f -name "*.control" | sort | while read -r cfile; do
        build_single_deb "${cfile}"
    done

    rm -rf "${BUILD_TEMP}"
    echo ""
    log_success "Tüm .deb paketleri hazır! Çıktı konumu: ${OUTPUT_DIR}"
}

build_all
