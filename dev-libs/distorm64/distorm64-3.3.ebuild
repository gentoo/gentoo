# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/distorm64/distorm64-3.3.ebuild,v 1.1 2013/11/04 12:11:19 slyfox Exp $

EAPI=5
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* 2.5"

inherit eutils distutils python versionator

DESCRIPTION="The ultimate disassembler library (X86-32, X86-64)"
HOMEPAGE="http://www.ragestorm.net/distorm/"

MY_PN=distorm
MY_PV=$(replace_all_version_separators '-')
MY_P=${MY_PN}${MY_PV}

SRC_URI="http://distorm.googlecode.com/files/${MY_P}-sdist.zip"
S="${WORKDIR}/${MY_P}"

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
