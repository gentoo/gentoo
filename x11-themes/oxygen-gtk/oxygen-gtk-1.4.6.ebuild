# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/oxygen-gtk/oxygen-gtk-1.4.6.ebuild,v 1.2 2015/02/20 16:16:30 zlogene Exp $

EAPI=5

MY_PN=${PN}2
MY_P=${MY_PN}-${PV}

inherit cmake-utils

DESCRIPTION="Official GTK+:2 port of KDE's Oxygen widget style"
HOMEPAGE="https://projects.kde.org/projects/playground/artwork/oxygen-gtk"
SRC_URI="mirror://kde/stable/${MY_PN}/${PV}/src/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
KEYWORDS="amd64 ~ppc x86"
SLOT="2"
IUSE="debug doc"

RDEPEND="
	!x11-themes/oxygen-gtk:0
	dev-libs/dbus-glib
	dev-libs/glib:2
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	>=x11-libs/gtk+-2.24.2:2
	x11-libs/libX11
	x11-libs/pango
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

DOCS=( AUTHORS README TODO )

S=${WORKDIR}/${MY_P}

src_install() {
	if use doc; then
		{ cd "${S}" && doxygen Doxyfile; } || die "Generating documentation failed"
		HTML_DOCS=( "${S}/doc/html/" )
	fi

	cmake-utils_src_install

	cat <<-EOF > 99oxygen-gtk2
CONFIG_PROTECT="${EPREFIX}/usr/share/themes/oxygen-gtk/gtk-2.0"
EOF
	doenvd 99oxygen-gtk2
}
