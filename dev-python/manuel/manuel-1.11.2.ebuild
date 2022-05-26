# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Lets you mix and match traditional doctests with custom test syntax"
HOMEPAGE="
	https://github.com/benji-york/manuel/
	https://pypi.org/project/manuel/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/zope-testing[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests setup.py

src_prepare() {
	# unused rdep
	sed -i -e "/'setuptools'/d" setup.py || die
	distutils-r1_src_prepare
}
