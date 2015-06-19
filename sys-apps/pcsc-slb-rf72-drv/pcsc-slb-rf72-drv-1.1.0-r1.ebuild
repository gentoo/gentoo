# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/pcsc-slb-rf72-drv/pcsc-slb-rf72-drv-1.1.0-r1.ebuild,v 1.11 2014/03/13 21:36:11 ulm Exp $

inherit eutils toolchain-funcs

MY_P="slb_rf72"
S=${WORKDIR}/${MY_P}
DESCRIPTION="Schlumberger Reflex 72 Serial Smartcard Reader"
HOMEPAGE="http://www.linuxnet.com/sourcedrivers.html"
LICENSE="all-rights-reserved BSD LGPL-2.1+"
KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"
SRC_URI="http://www.linuxnet.com/drivers/readers/files/slb_rf72-drv-1.1.0.tar.gz"
RESTRICT="mirror bindist"

RDEPEND="sys-apps/pcsc-lite
	dev-libs/openct"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/${P}-build.patch"
}

src_compile() {
	emake CC="$(tc-getCC)" LD="$(tc-getLD)" || die
}

src_install () {
	local pcscdir="$(pkg-config --variable=usbdropdir libpcsclite)"
	local conf="/etc/reader.conf.d/${PN}.conf"

	dodoc ERRATA README

	dodir "${pcscdir}/serial"
	insinto "${pcscdir}/serial"
	insopts -m755
	doins libslb_rf72.so

	dodir "$(dirname "${conf}")"
	insinto "$(dirname "${conf}")"
	newins "${FILESDIR}/reader.conf" "$(basename "${conf}")"
	sed -i "s#%PCSC_DRIVERS_DIR%#${pcscdir}#g" "${D}/${conf}"

	einfo "NOTICE:"
	einfo "1. modify ${conf}"
	einfo "2. run update-reader.conf, yes this is a command..."
	einfo "3. restart pcscd"
}

pkg_postrm() {
	#
	# Without this, pcscd will not start next time.
	#
	local conf="/etc/reader.conf.d/${PN}.conf"
	if ! [ -f "$(grep LIBPATH "${conf}" | sed 's/LIBPATH *//' | sed 's/ *$//g' | head -n 1)" ]; then
		rm "${conf}"
		update-reader.conf
		einfo "NOTICE:"
		einfo "You need to restart pcscd"
	fi
}
