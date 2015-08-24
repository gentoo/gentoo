# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

WX_GTK_VER="2.8"
PYTHON_DEPEND="2:2.7"

inherit eutils multilib python wxwidgets

DESCRIPTION="A fractal flame editor"
HOMEPAGE="http://fr0st.wordpress.com/"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}.0/+download/${P}-src.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/wxpython:2.8
	>=media-gfx/flam3-3.0.1"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${P}-src

pkg_setup() {
	fr0st_libdir="/usr/$(get_libdir)/fr0st"
	fr0st_sharedir="/usr/share/fr0st"

	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	python_convert_shebangs 2 fr0st.py
}

src_install() {
	insinto "${fr0st_sharedir}"
	doins -r icons samples || die

	insinto "${fr0st_libdir}"
	doins -r fr0stlib || die

	exeinto "${fr0st_libdir}"
	doexe fr0st.py || die

	dosym "${fr0st_libdir}"/fr0st.py /usr/bin/fr0st || die
	dosym "${fr0st_sharedir}"/icons/fr0st.png /usr/share/pixmaps/fr0st.png || die

	make_desktop_entry fr0st fr0st

	dodoc changelog.txt
}

pkg_postinst() {
	python_mod_optimize "${fr0st_libdir}"
}

pkg_postrm() {
	python_mod_cleanup "${fr0st_libdir}"
}
