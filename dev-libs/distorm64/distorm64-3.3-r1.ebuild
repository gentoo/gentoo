# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 versionator

DESCRIPTION="The ultimate disassembler library (X86-32, X86-64)"
HOMEPAGE="http://www.ragestorm.net/distorm/"

MY_PN=distorm
MY_PV=$(replace_all_version_separators '-')
MY_P=${MY_PN}${MY_PV}

SRC_URI="https://distorm.googlecode.com/files/${MY_P}-sdist.zip"
S="${WORKDIR}/${MY_P}"

DEPEND="app-arch/unzip"
RDEPEND=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
