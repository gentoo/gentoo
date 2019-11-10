# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Firmware Tool for Broadcom 43xx based wireless network devices"
HOMEPAGE="http://bcm43xx.berlios.de"
#SRC_URI="mirror://berlios/bcm43xx/${P}.tar.bz2"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ppc ~ppc64 ~x86"
IUSE=""

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	# Install fwcutter
	dobin ${PN}
	doman ${PN}.1
	dodoc README
}

pkg_postinst() {
	if [[ ! -f ${EROOT}/lib/firmware/${PN}_microcode2.fw ]]; then
		elog "You'll need to use bcm43xx-fwcutter to install the bcm43xx firmware."
		elog "Please read the bcm43xx-fwcutter readme for more details:"
		elog "README in /usr/share/doc/${PF}"
		elog
	fi

	elog "Please read this forum thread for help and troubleshooting:"
	elog "https://forums.gentoo.org/viewtopic-t-409194.html"
}
