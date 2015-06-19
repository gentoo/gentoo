# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/driconf/driconf-0.9.1-r1.ebuild,v 1.8 2014/08/10 20:02:12 slyfox Exp $

EAPI="3"
PYTHON_DEPEND="2"
PYTHON_USE_WITH="xml"

inherit distutils eutils

DESCRIPTION="driconf is a GTK+2 GUI configurator for DRI"
HOMEPAGE="http://dri.freedesktop.org/wiki/DriConf"
SRC_URI="http://freedesktop.org/~fxkuehl/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~sparc x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.4:2
	>=dev-python/pygtk-2.4:2
	x11-apps/xdriinfo"
DEPEND="${RDEPEND}"

DOCS="CHANGELOG COPYING PKG-INFO README TODO"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-glxinfo-unicode.patch \
		"${FILESDIR}"/${P}-update-toolbar-methods.patch \
		"${FILESDIR}"/${P}-driconf_simpleui.py.patch

	# Fix install locations which breaks location policy - Josh_B
	sed -i \
		-e 's-/usr/local-/usr-g' \
		driconf \
		driconf.desktop \
		driconf.py \
		setup.cfg \
		setup.py \
		|| die "Sed failed!"
}

src_install() {
	distutils_src_install
	domenu driconf.desktop
}

pkg_postinst() {
	python_mod_optimize /usr/lib/driconf
}

pkg_postrm() {
	python_mod_cleanup /usr/lib/driconf
}
