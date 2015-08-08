# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils qt4-r2

MY_PN="DNetStats"
MY_P="${MY_PN}-v${PV}-release"

DESCRIPTION="Qt4 network monitor utility"
HOMEPAGE="http://qt-apps.org/content/show.php/DNetStats?content=107467"
SRC_URI="http://qt-apps.org/CONTENT/content-files/107467-${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="policykit"

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
"
RDEPEND="${DEPEND}
	policykit? ( sys-auth/polkit )
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	qt4-r2_src_prepare

	# clueless upstream ships generated files...
	rm -rf moc_* qrc_* || die
}

src_install() {
	newbin mythread ${PN}
	dodoc ReadMe

	newicon resource/energy.png ${PN}.png
	make_desktop_entry ${PN} DNetStats ${PN} 'Qt;Network;Dialup'

	if use policykit; then
		insinto /usr/share/polkit-1/actions
		doins "${FILESDIR}/org.gentoo.pkexec.${PN}.policy"
		sed -i -e 's/^Exec=/&pkexec /' \
			"${ED}"usr/share/applications/${PN}*.desktop \
			|| die
	fi
}
