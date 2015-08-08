# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* 2.5"

inherit eutils distutils python

DESCRIPTION="The ultimate disassembler library (X86-32, X86-64)"
HOMEPAGE="http://www.ragestorm.net/distorm/"

# This is not nice - hardcoding is bad
SRC_URI="http://distorm.googlecode.com/files/distorm3-1.0.zip"
S="${WORKDIR}/distorm3-1.0"

DEPEND="app-arch/unzip"
RDEPEND=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

pkg_setup() {
	python_pkg_setup
}

src_compile() {
	distutils_src_compile
}
