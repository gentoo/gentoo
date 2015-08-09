# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG=no

PYTHON_COMPAT=( python2_7 )
inherit gnome2 python-single-r1

DESCRIPTION="A clone of classic hearts card game"
HOMEPAGE="http://www.gnome-hearts.org"
SRC_URI="http://www.jejik.com/files/${PN}/${P}.tar.gz"

LICENSE="GPL-2 FDL-1.2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

RDEPEND="x11-libs/gtk+:2
	>=gnome-base/libglade-2
	>=gnome-base/libgnomeui-2
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	app-text/rarian
	dev-util/intltool
	virtual/pkgconfig"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_prepare() {
	# make src_test work
	echo gnome-hearts.desktop.in >> po/POTFILES.skip

	sed -i \
		-e '/No name/d' \
		-e '/^Icon/s/.png//' \
		-e '/^Encoding/d' \
		gnome-hearts.desktop.in || die

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable nls)
}
