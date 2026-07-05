# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="Auto documentation for MkDocs"
HOMEPAGE="
	https://github.com/lovelydinosaur/mkautodoc/
	https://pypi.org/project/mkautodoc/
"
SRC_URI="
	https://github.com/lovelydinosaur/mkautodoc/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/markdown[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_test() {
	local -x PYTHONPATH="${WORKDIR}/${P}/tests/mocklib:${WORKDIR}/${P}"
	distutils-r1_src_test
}
