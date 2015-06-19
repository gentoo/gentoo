# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/pychess/pychess-0.10.1-r2.ebuild,v 1.6 2015/02/01 17:30:14 mr_bones_ Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit fdo-mime gnome2-utils distutils-r1 games

DESCRIPTION="A chess client for Gnome"
HOMEPAGE="http://pychess.googlepages.com/home"
SRC_URI="http://pychess.googlecode.com/files/${P/_/}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="gstreamer"

DEPEND="dev-python/librsvg-python
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	dev-python/pygtksourceview:2[${PYTHON_USEDEP}]
	gstreamer? ( dev-python/gst-python:0.10[${PYTHON_USEDEP}] )
	dev-python/gconf-python
	x11-themes/gnome-icon-theme"
RDEPEND=${DEPEND}

PATCHES=( "${FILESDIR}"/${P}-python.patch )

S=${WORKDIR}/${P/_/}

python_install() {
	distutils-r1_python_install --install-scripts="${GAMES_BINDIR}"

	# bug 487706
	sed -i \
		-e "s/@PYTHON@/${EPYTHON}/" \
		"${ED%/}/$(python_get_sitedir)"/${PN}/Players/engineNest.py || die
}

python_install_all() {
	distutils-r1_python_install_all
	dodoc AUTHORS README
	prepgamesdirs
}

src_prepare() {
	distutils-r1_src_prepare
}

src_compile() {
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
}
