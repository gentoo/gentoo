# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_EAUTORECONF="yes"
PYTHON_COMPAT=( python2_7 )

inherit gnome2 python-single-r1

DESCRIPTION="A clone of classic hearts card game"
HOMEPAGE="http://www.gnome-hearts.org"
SRC_URI="http://www.jejik.com/files/${PN}/${P}.tar.gz"

LICENSE="GPL-2+ FDL-1.2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	x11-libs/gtk+:2
	>=gnome-base/libglade-2
"
DEPEND="${RDEPEND}
	app-text/rarian
	dev-util/intltool
	virtual/pkgconfig
"

src_prepare() {
	# make src_test work
	echo gnome-hearts.desktop.in >> po/POTFILES.skip

	sed -i \
		-e '/No name/d' \
		-e '/^Icon/s/.png//' \
		-e '/^Encoding/d' \
		gnome-hearts.desktop.in || die

	eapply "${FILESDIR}"/${P}-drop-libgnomeui.patch

	mv configure.in configure.ac || die
	gnome2_src_prepare
}
