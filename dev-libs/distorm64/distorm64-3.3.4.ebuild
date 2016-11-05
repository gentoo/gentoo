# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

# does not work with python3_4 as-is
PYTHON_COMPAT=( python2_7 python3_4 )

inherit distutils-r1

DESCRIPTION="The ultimate disassembler library (X86-32, X86-64)"
HOMEPAGE="http://www.ragestorm.net/distorm/"

MY_PN=distorm
MY_P=${MY_PN}-${PV}

SRC_URI="https://github.com/gdabah/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

DEPEND=""
RDEPEND=""

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
