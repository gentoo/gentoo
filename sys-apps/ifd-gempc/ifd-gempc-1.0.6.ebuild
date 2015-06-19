# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/ifd-gempc/ifd-gempc-1.0.6.ebuild,v 1.2 2012/05/04 09:17:30 jdhore Exp $

inherit toolchain-funcs

DESCRIPTION="GemCore based PC/SC reader drivers for pcsc-lite"
HOMEPAGE="http://ludovic.rousseau.free.fr/softwares/ifd-GemPC"
LICENSE="GPL-2 BSD"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
SRC_URI="http://ludovic.rousseau.free.fr/softwares/ifd-GemPC/${P}.tar.gz"
IUSE=""
RDEPEND=">=sys-apps/pcsc-lite-1.2.9_beta7
	=virtual/libusb-0*"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install () {
	local pcscdir="$(pkg-config --variable=usbdropdir libpcsclite)"
	local conf="/etc/reader.conf.d/${PN}.conf"
	emake CC="$(tc-getCC)" DESTDIR="${D}" install || die "emake install failed"
	dodoc README*
	dodir "$(dirname "${conf}")"
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
