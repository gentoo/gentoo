EAPI=8
inherit desktop xdg unpacker

DESCRIPTION="Thorium Browser: A fast and secure browser for the modern web."
HOMEPAGE="https://github.com/Alex313031/thorium"

# Adding USE flags for CPU instruction set
IUSE="+avx2 sse3"

# Conditional SRC_URI based on USE flags
SRC_URI="avx2? ( https://github.com/Alex313031/thorium/releases/download/M${PV}/thorium-browser_${PV}_AVX2.deb )
         sse3? ( https://github.com/Alex313031/thorium/releases/download/M${PV}/thorium-browser_${PV}_SSE3.deb )"

RESTRICT="strip"
LICENSE="BSD-3-Clause-Thorium"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
    dev-libs/nss
    dev-libs/icu
"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_unpack() {
    unpack_deb "${A}" || die "Failed to unpack deb file"
    mv "${WORKDIR}/opt/chromium.org/thorium" "${S}" || die "Failed to move files to ${S}"
}

src_install() {
    local install_dir="/opt/thorium-browser-bin"  # Target installation directory
    dodir "${install_dir}"
    cp -r "${S}/thorium/." "${D}${install_dir}" || die "Failed to copy Thorium files to destination directory"
    fperms 0755 "${install_dir}/thorium" \
                "${install_dir}/thorium-browser" \
                "${install_dir}/thorium_shell" \
                "${install_dir}/chrome-sandbox"
    dosym "${install_dir}/thorium-browser" "/usr/bin/thorium-browser"
    dosym "${install_dir}/thorium" "/usr/bin/thorium"

    local sizes=(16 24 32 48 64 128 256)
    for size in "${sizes[@]}"; do
        local icon_path="${install_dir}/product_logo_${size}.png"
        local icon_name="thorium-browser-${size}"
        if [[ -e "${D}${icon_path}" ]]; then
            newicon "${D}${icon_path}" "${icon_name}"
        else
            eerror "Icon file ${icon_path} not found in ${D}${install_dir}. Skipping installation."
        fi
    done

    # Create desktop entry without the file extension for the icon
    make_desktop_entry "thorium-browser" "Thorium Browser" "thorium-browser-128" "Network;WebBrowser;"

	# Install license file
    local license_dir="/usr/share/licenses/${PN}"
    dodir "${license_dir}"
    insinto "${license_dir}"
    newins "${FILESDIR}/BSD-3-Clause-Thorium" "BSD-3-Clause-Thorium.txt"
}

# Add multilib-strict-skip flag before any phases
export PORTAGE_EBUILD_PHASES="multilib-strict-skip ${PORTAGE_EBUILD_PHASES}"

