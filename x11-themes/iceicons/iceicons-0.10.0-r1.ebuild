# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="IceWM Icons is a set of XPM 16x16, 32x32, and 48x48 XPM and PNG icons for IceWM"
HOMEPAGE="http://sandbox.cz/~covex/icewm/iceicons/"
SRC_URI="http://sandbox.cz/~covex/icewm/iceicons/${PN}-default-${PV}.tar.gz"
LICENSE="LGPL-2.1"

SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE=""

RDEPEND=">=x11-wm/icewm-1.2.6"
DEPEND="${RDEPEND}"

S="${WORKDIR}"
ICEICONSDIR="/usr/share/icewm/icons/iceicons"

src_install() {
	dodir "${ICEICONSDIR}"
	cp -pPR icons/* "${D}"/"${ICEICONSDIR}" || die
	chown -R root:0 "${D}"/"${ICEICONSDIR}" || die
	chmod -R o-w "${D}"/"${ICEICONSDIR}" || die

	dodoc CHANGELOG README TODO winoptions
}

pkg_postinst() {
	einfo
	einfo "To use new IceWm icons, add following"
	einfo "into your IceWm preference file:"
	einfo "IconPath=\"${ICEICONSDIR}:${ICEICONSDIR}/menuitems\""
	einfo
}

pkg_postrm(){
	einfo
	einfo "Update your IceWm preference."
	einfo
}
