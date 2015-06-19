# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/gwp/gwp-0.4.0-r3.ebuild,v 1.4 2015/02/14 03:49:34 mr_bones_ Exp $

EAPI=5
GCONF_DEBUG="yes"
PYTHON_COMPAT=( python2_7 )

inherit eutils flag-o-matic gnome2 python-single-r1

DESCRIPTION="GNOME client for the classic PBEM strategy game VGA Planets 3"
HOMEPAGE="http://gwp.lunix.com.ar/"
SRC_URI="http://gwp.lunix.com.ar/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls opengl python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="x11-libs/gtk+:2
	gnome-base/libgnomeui
	gnome-base/libglade
	app-text/rarian
	dev-libs/libpcre
	nls? ( virtual/libintl )
	opengl? ( x11-libs/gtkglext )
	python? ( ${PYTHON_DEPS}
		dev-python/pygtk[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	append-libs -lm
	epatch \
		"${FILESDIR}"/${P}-gcc41.patch \
		"${FILESDIR}"/${P}-exec-stack.patch
	sed -i \
		-e '/ -O1/d' \
		-e '/ -g$/d' \
		src/Makefile.in || die
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable nls) \
		$(use_enable opengl gtkglext) \
		$(use_enable python)
}

src_install() {
	DOCS="AUTHORS ChangeLog CHANGES README TODO" \
	gnome2_src_install
	rm -rf "${D}"/usr/share/doc/gwp
}
