# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

CSS_TEST_COMMIT_ID=c5749e51dda3868b3e8062e65a36584c2fec8059

DESCRIPTION="A complete yet simple CSS parser for Python"
HOMEPAGE="
	https://www.courtbouillon.org/tinycss2
	https://github.com/Kozea/tinycss2/
	https://pypi.org/project/tinycss2/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
SRC_URI="
	https://github.com/Kozea/tinycss2/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz
	test? (
		https://github.com/SimonSapin/css-parsing-tests/archive/${CSS_TEST_COMMIT_ID}.tar.gz
			-> css-parsing-tests-${CSS_TEST_COMMIT_ID}.gh.tar.gz
	)
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	>=dev-python/webencodings-0.4[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/addopts/d' pyproject.toml || die
	if use test; then
		mv "${WORKDIR}/css-parsing-tests-${CSS_TEST_COMMIT_ID}"/* \
			tests/css-parsing-tests/ || die
	fi
	distutils-r1_src_prepare
}
