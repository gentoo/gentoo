# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 2.5 3.* *-jython 2.7-pypy-*"

inherit distutils eutils multilib python

DESCRIPTION="Font preview application"
HOMEPAGE="http://savannah.nongnu.org/projects/fontypython"
SRC_URI="http://download.savannah.nongnu.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# Crashes w/ debug build of wxGTK (#201315)
DEPEND="dev-python/pillow
	dev-python/wxpython:2.8
	x11-libs/wxGTK:2.8[-debug]"
RDEPEND="${DEPEND}"

PYTHON_MODNAME="fontypythonmodules"

src_prepare() {
	epatch "${FILESDIR}/${PN}-pillow.patch"
}

src_install() {
	distutils_src_install
	doman "${S}"/fontypython.1
}
