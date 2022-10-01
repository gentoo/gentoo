# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="GemCore based PC/SC reader drivers for pcsc-lite"
HOMEPAGE="http://ludovic.rousseau.free.fr/softwares/ifd-GemPC"
SRC_URI="http://ludovic.rousseau.free.fr/softwares/ifd-GemPC/${P}.tar.gz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	>=sys-apps/pcsc-lite-1.2.9_beta7
	virtual/libusb:0
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( README README.410 README.430 )

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake CC="$(tc-getCC)" DESTDIR="${D}" install
	einstalldocs

	local pcscdir="$($(tc-getPKG_CONFIG) --variable=usbdropdir libpcsclite)"
	local conf="/etc/reader.conf.d/${PN}.conf"

	insinto "$(dirname "${conf}")"
	newins "${FILESDIR}/reader.conf" "$(basename "${conf}")"
	sed -e "s:%PCSC_DRIVERS_DIR%:${pcscdir}:g" -e "s:%libGemPC410%:libGemPC410.so.${PV}:g" -i "${D}${conf}"
}

pkg_postinst() {
	elog "NOTICE:"
	elog "1. If you are using GemPC410, modify ${conf}"
	elog "2. Run update-reader.conf, yes this is a command..."
	elog "3. Restart pcscd"
}

pkg_postrm() {
	#
	# Without this, pcscd will not start next time.
	#
	local conf="/etc/reader.conf.d/${PN}.conf"
	if ! [[ -f "${conf}" && -f "$(grep LIBPATH "${conf}" | sed 's/LIBPATH *//' | sed 's/ *$//g' | head -n 1)" ]]; then
		[[ -f "${conf}" ]] && rm "${conf}"
		update-reader.conf
		elog "NOTICE:"
		elog "You need to restart pcscd"
	fi
}
