# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7,8}} )

inherit distutils-r1

DESCRIPTION="The ultimate disassembler library (X86-32, X86-64)"
HOMEPAGE="http://www.ragestorm.net/distorm/"

MY_PN=distorm3
MY_P=${MY_PN}-${PV}

SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

DEPEND=""
RDEPEND=""

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

python_install() {
	distutils-r1_python_install

	# don't know why it does not happen by default
	python_optimize
}
