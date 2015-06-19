# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/distorm64/distorm64-3.3-r1.ebuild,v 1.1 2014/11/30 14:48:26 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 versionator

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
