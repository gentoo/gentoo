# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils

MY_PN="doublecmd"
DESCRIPTION="Free cross platform open source file manager with two panels side by side."
HOMEPAGE="http://doublecmd.sourceforge.net/"

SRC_URI="amd64? ( gtk? ( mirror://sourceforge/${MY_PN}/${MY_PN}-${PV}.gtk2.x86_64.tar.xz )
		qt5?  ( mirror://sourceforge/${MY_PN}/${MY_PN}-${PV}.qt5.x86_64.tar.xz ) )
	x86? ( gtk? ( mirror://sourceforge/${MY_PN}/${MY_PN}-${PV}.gtk2.i386.tar.xz )
		qt5?  ( mirror://sourceforge/${MY_PN}/${MY_PN}-${PV}.qt5.i386.tar.xz ) )"

# Licenses for package and plugins
LICENSE="GPL-2+ LGPL-2-with-linking-exception LGPL-2.1+ LGPL-3 GPL-1 freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="gtk qt5"
REQUIRED_USE=" ^^ ( gtk qt5 ) "

RESTRICT="mirror"

S="${WORKDIR}/${MY_PN}"

QA_PREBUILT="
	*/doublecmd
	*/libQt5Pas.so.1
"

## "ldd doublecmd" output show linking to some libraries provided by sys-libs/glibc:2.2
## (maybe virtual/libc-1) and no libraries of sys-libs/ncurses (that removed here).
## x11-libs/X11 is optional dependency of dev-qt/qtgui:5 by [xcb] or [X]
## therefore it is mentioned here explicitly.
RDEPEND="
	dev-libs/glib:2
	sys-apps/dbus
	x11-libs/libX11
	virtual/libc
	gtk? ( x11-libs/gtk+:2 )
	qt5? (
		dev-qt/qtgui:5
		dev-qt/qtx11extras:5
	)
"

src_prepare(){
	default
	## Create partial init config that allows to store config within user home directory
	cp "${FILESDIR}/doublecmd.xml" "${S}/"
}

src_install(){
	insinto "/opt/${PN}"
	doins -r "${S}/."

	exeinto "/opt/${PN}"
	doexe "${S}/${MY_PN}"
	doexe "${S}/${MY_PN}.sh"

	doicon -s 48 ${MY_PN}.png
	make_desktop_entry "/opt/${PN}/${MY_PN}.sh" "Double Commander" "${MY_PN}" "Utility;" || die "Failed making desktop entry!"
}
