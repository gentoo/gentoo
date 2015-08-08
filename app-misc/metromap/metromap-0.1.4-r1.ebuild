# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 gnome2-utils

DESCRIPTION="Metromap is simple pygtk+2 programm for finding paths in metro(subway) maps"
HOMEPAGE="http://metromap.antex.ru/"
SRC_URI="http://metromap.antex.ru/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	>=dev-python/pygtk-2.8:2[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

src_prepare() {
	python_fix_shebang .
	sed -e 's,Gtk;,GTK;,' -i metromap.desktop || die
}

src_compile() { :; }

src_install() {
	emake DESTDIR="${ED}"/usr install
	python_optimize "${ED}"/usr/share/metromap/modules/
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
