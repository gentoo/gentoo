# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite,xml"

inherit gnome2-utils distutils-r1

DESCRIPTION="A note taking application"
HOMEPAGE="http://keepnote.org/"
SRC_URI="http://keepnote.org/download-test/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
SLOT="0"
IUSE=""

RDEPEND="dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/pygtk:2[${PYTHON_USEDEP}]
	x11-misc/xdg-utils"

PATCHES=( "${FILESDIR}"/${PN}-0.7.8-desktopfile.patch )
DOCS=( CHANGES )

python_test() {
	"${PYTHON}" test/testing.py || die
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update

	einfo
	elog "optional dependencies:"
	elog "  app-text/gtkspell:2 (spell checking)"
	einfo
}

pkg_postrm() {
	gnome2_icon_cache_update
}
