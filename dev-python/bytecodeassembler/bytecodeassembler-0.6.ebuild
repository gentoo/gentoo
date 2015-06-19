# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/bytecodeassembler/bytecodeassembler-0.6.ebuild,v 1.6 2015/04/08 08:04:58 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

MY_PN="BytecodeAssembler"

DESCRIPTION="Generate Python code objects by "assembling" bytecode"
HOMEPAGE="http://pypi.python.org/pypi//BytecodeAssembler"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.zip -> ${P}.zip"

KEYWORDS="amd64 x86"
IUSE=""
LICENSE="Apache-2.0"
SLOT="0"

RDEPEND=""
DEPEND="app-arch/unzip
	>=dev-python/symboltype-1.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}"/${MY_PN}-${PV}

python_test() {
	"${PYTHON}" test_assembler.py && einfo "Tests passed under ${EPYTHON}" \
		|| die "Tests failed under ${EPYTHON}"
}
