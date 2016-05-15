# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
WX_GTK_VER="3.0"
PYTHON_COMPAT=( python2_7 )

inherit eutils multilib python-single-r1 wxwidgets

DESCRIPTION="A fractal flame editor"
HOMEPAGE="http://fr0st.wordpress.com/"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}.0/+download/${P}-src.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/wxpython:${WX_GTK_VER}
	>=media-gfx/flam3-3.0.1
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}-src"

pkg_setup() {
	fr0st_libdir="/usr/$(get_libdir)/fr0st"
	fr0st_sharedir="/usr/share/fr0st"

	python-single-r1_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-colour.patch #564106
	python_fix_shebang .
	need-wxwidgets unicode
}

src_install() {
	insinto "${fr0st_sharedir}"
	doins -r icons samples

	insinto "${fr0st_libdir}"
	doins -r fr0stlib

	exeinto "${fr0st_libdir}"
	doexe fr0st.py

	dosym "${fr0st_libdir}"/fr0st.py /usr/bin/fr0st
	dosym "${fr0st_sharedir}"/icons/fr0st.png /usr/share/pixmaps/fr0st.png

	make_desktop_entry fr0st fr0st

	dodoc changelog.txt
}
