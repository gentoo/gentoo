# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/lutris/lutris-0.3.6.2.ebuild,v 1.3 2015/04/19 10:08:58 ago Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite,threads"

inherit distutils-r1 gnome2-utils games

DESCRIPTION="Gaming platform for GNU/Linux"
HOMEPAGE="http://lutris.net/"
SRC_URI="https://github.com/lutris/lutris/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	gnome-base/gvfs[http]
	x11-apps/xrandr
	x11-apps/xgamma
	x11-misc/xdg-utils"

# INSTALL contains list of optional deps
DOCS=( AUTHORS README.rst INSTALL )

python_install() {
	distutils-r1_python_install --install-scripts="${GAMES_BINDIR}"
}

src_prepare() {
	distutils-r1_src_prepare
}

src_compile() {
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
	gnome2_schemas_update

	elog "For a list of optional deps (runners), see"
	elog "/usr/share/doc/${PF}/INSTALL"
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}
