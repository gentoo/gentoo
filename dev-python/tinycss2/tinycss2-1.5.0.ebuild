# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

CSS_TEST_COMMIT_ID=88fc3fc33986f835b6658b1b824b50c9550723f8

DESCRIPTION="A complete yet simple CSS parser for Python"
HOMEPAGE="
	https://www.courtbouillon.org/tinycss2/
	https://github.com/Kozea/tinycss2/
	https://pypi.org/project/tinycss2/
"
SRC_URI+="
	test? (
		https://github.com/CourtBouillon/css-parsing-tests/archive/${CSS_TEST_COMMIT_ID}.tar.gz
			-> css-parsing-tests-${CSS_TEST_COMMIT_ID}.gh.tar.gz
	)
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	>=dev-python/webencodings-0.4[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_prepare() {
	if use test; then
		mv "${WORKDIR}/css-parsing-tests-${CSS_TEST_COMMIT_ID}"/* \
			tests/css-parsing-tests/ || die
	fi
	distutils-r1_src_prepare
}
