# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Python module to propose a modern general-purpose parsing library for Python"
HOMEPAGE="https://github.com/lark-parser/lark"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-python/regex[${PYTHON_USEDEP}]
		dev-python/js2py[${PYTHON_USEDEP}]
	)"

python_test() {
	"${EPYTHON}" -m tests || die "Tests fail with ${EPYTHON}"
}
