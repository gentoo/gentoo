# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit xfconf

MY_PN=Xfce-Theme-Manager
MY_P=${MY_PN}-${PV}

DESCRIPTION="An alternative theme manager for The Xfce Desktop Environment"
HOMEPAGE="http://keithhedger.hostingsiteforfree.com/pages/apps.html#themeed"
SRC_URI="http://keithhedger.hostingsiteforfree.com/zips/xfcethememanager/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.30
	>=x11-libs/gtk+-2.24:2
	x11-libs/libXcursor
	>=xfce-base/libxfce4ui-4.10
	>=xfce-base/xfconf-4.10
	>=xfce-base/xfdesktop-4.10"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	DOCS=( ChangeLog )
}

src_prepare() {
	sed -i \
		-e '/^Cat/s:;;Settings::' \
		-e '/^Cat/s:Gnome:GNOME:' \
		${MY_PN}/resources/pixmaps/${MY_PN}.desktop || die

	local configext desktopversion=10
	has_version '>=xfce-base/xfdesktop-4.11' && desktopversion=11
	[[ -x configure ]] || configext=.ac

	sed -i \
		-e '/^CFLAGS/s:=-Wall:"& $CFLAGS":' \
		-e '/^CXXFLAGS/s:=-Wall:"& $CXXFLAGS":' \
		-e "/^desktopversion/s:=.*:=$desktopversion:" \
		configure${configext} || die

	xfconf_src_prepare
}

src_install() {
	xfconf_src_install
	rm -f "${ED}"/usr/share/${MY_PN}/docs/gpl-3.0.txt
}
