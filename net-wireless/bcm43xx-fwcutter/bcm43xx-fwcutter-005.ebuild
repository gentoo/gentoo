# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="Firmware Tool for Broadcom 43xx based wireless network devices"
HOMEPAGE="http://bcm43xx.berlios.de"
SRC_URI="mirror://berlios/bcm43xx/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~x86 ~ppc64"
IUSE=""

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	# Install fwcutter
	dobin ${PN}
	doman ${PN}.1
	dodoc README
}

pkg_postinst() {
	if ! [ -f /lib/firmware/${PN}_microcode2.fw ]; then
		echo
		einfo "You'll need to use bcm43xx-fwcutter to install the bcm43xx firmware."
		einfo "Please read the bcm43xx-fwcutter readme for more details:"
		einfo "README in /usr/share/doc/${P}/"
		echo
	fi

	einfo "Please read this forum thread for help and troubleshooting:"
	einfo "http://forums.gentoo.org/viewtopic-t-409194.html"
	echo
}
