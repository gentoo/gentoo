# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/gramps/gramps-3.4.5-r1.ebuild,v 1.3 2015/03/02 09:20:57 ago Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
GCONF_DEBUG="no"

inherit eutils gnome2 python-single-r1

DESCRIPTION="Genealogical Research and Analysis Management Programming System"
HOMEPAGE="http://www.gramps-project.org/"
SRC_URI="mirror://sourceforge/gramps/Stable/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

IUSE="gnome reports spell webkit"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/bsddb3[${PYTHON_USEDEP}]
	>=dev-python/pygtk-2.16.0[${PYTHON_USEDEP}]
	dev-python/pygoocanvas[${PYTHON_USEDEP}]
	x11-misc/xdg-utils
	gnome-base/librsvg:2
	gnome? (
		dev-python/libgnome-python[${PYTHON_USEDEP}]
		dev-python/gconf-python[${PYTHON_USEDEP}] )
	spell? ( dev-python/gtkspell-python[${PYTHON_USEDEP}] )
	reports? ( media-gfx/graphviz )
	webkit? ( dev-python/pywebkitgtk[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/libiconv
	virtual/pkgconfig
"

src_prepare() {
	epatch "${FILESDIR}/${PN}-3.4.0-use_bsddb3.patch"

	# Fix install path, bug 423315 for example
	einfo "Fix installation path"
	find . -iname 'Makefile.in' | xargs \
		sed "s;\(pkgdatadir = \)\(\$(datadir)\);\1$(python_get_sitedir);" -i \
		|| die
	find . -iname 'Makefile.in' | xargs \
		sed "s;\(pkgpythondir = \)\(\$(datadir)\);\1$(python_get_sitedir);" -i \
		|| die

	sed "s;\$(prefix)/share/gramps;/$(python_get_sitedir)/@PACKAGE@;" \
		-i src/Makefile.in || die

	sed "s;\$(prefix)/share/gramps;/$(python_get_sitedir)/@PACKAGE@;" \
	-i src/docgen/Makefile.in || die

	einfo "Fix wrapper script"
	sed "s;@datadir@;$(python_get_sitedir);" \
		-i gramps.sh.in || die

	einfo "Fix icon location"
	sed "s;gramps/;pixmap/;g" -i data/gramps.keys.in || die

	python_fix_shebang .

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-mime-install \
		PYTHON="${EROOT}"/usr/bin/python2
}
