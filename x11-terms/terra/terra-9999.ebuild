# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/terra/terra-9999.ebuild,v 1.4 2015/04/08 17:26:26 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_IN_SOURCE_BUILD=1
inherit bzr distutils-r1

DESCRIPTION="Terminal emulator with split-screen support"
HOMEPAGE="https://launchpad.net/terra"
EBZR_REPO_URI="lp:terra"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="<dev-python/python-distutils-extra-2.34"
RDEPEND="dev-libs/gobject-introspection
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/python-xlib
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3[introspection]
	x11-libs/vte:2.90[introspection]"

src_install() {
	distutils-r1_src_install
	rm -f "${D}"/usr/share/doc/terra/README.md
}
