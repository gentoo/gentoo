# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN=${PN}3
MY_P=${MY_PN}-${PV}

inherit cmake-utils

DESCRIPTION="Official GTK+:3 port of KDE's Oxygen widget style"
HOMEPAGE="https://projects.kde.org/projects/playground/artwork/oxygen-gtk"
SRC_URI="mirror://kde/stable/${MY_PN}/${PV}/src/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
KEYWORDS="amd64 ~ppc x86"
SLOT="3"
IUSE="debug doc"

RDEPEND="
	!x11-themes/oxygen-gtk:0
	dev-libs/dbus-glib
	dev-libs/glib:2
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	>=x11-libs/gtk+-3.10:3
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

	cat <<-EOF > 99oxygen-gtk3
CONFIG_PROTECT="${EPREFIX}/usr/share/themes/oxygen-gtk/gtk-3.0"
EOF
	doenvd 99oxygen-gtk3
}
