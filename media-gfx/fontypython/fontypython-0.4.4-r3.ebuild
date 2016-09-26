# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
WX_GTK_VER=3.0
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 multilib wxwidgets

DESCRIPTION="Font preview application"
HOMEPAGE="https://savannah.nongnu.org/projects/fontypython"
SRC_URI="http://download.savannah.nongnu.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

# Crashes w/ debug build of wxGTK (#201315)
DEPEND="dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/wxpython:${WX_GTK_VER}[${PYTHON_USEDEP}]
	x11-libs/wxGTK:${WX_GTK_VER}[-debug]"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-pillow.patch"
	"${FILESDIR}"/0001-Do-not-crash-on-empty-pogs-list.patch
	"${FILESDIR}"/0002-Removed-unused-code-which-causes-crash-with-wx-3.0.patch
	"${FILESDIR}"/0003-Adapt-to-wxpython-3.0-which-enforces-assertions-on-L.patch )

src_prepare() {
	distutils-r1_src_prepare
	need-wxwidgets unicode
}

src_install() {
	distutils-r1_src_install
	doman "${S}"/fontypython.1
}
