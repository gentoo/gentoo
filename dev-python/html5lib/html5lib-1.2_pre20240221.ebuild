# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

EGIT_COMMIT="fd4f032bc090d44fb11a84b352dad7cbee0a4745"
# html5lib/tests/testdata
TEST_COMMIT="9b4a29c943b3c905e46b26569bae16de8b373516"
MY_P=html5lib-python-${EGIT_COMMIT}
TEST_P=html5lib-tests-${TEST_COMMIT}

DESCRIPTION="HTML parser based on the HTML5 specification"
HOMEPAGE="
	https://github.com/html5lib/html5lib-python/
	https://html5lib.readthedocs.io/
	https://pypi.org/project/html5lib/
"
SRC_URI="
	https://github.com/html5lib/html5lib-python/archive/${EGIT_COMMIT}.tar.gz
		-> ${MY_P}.gh.tar.gz
	test? (
		https://github.com/html5lib/html5lib-tests/archive/${TEST_COMMIT}.tar.gz
			-> ${TEST_P}.gh.tar.gz
	)
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

RDEPEND="
	>=dev-python/six-1.9[${PYTHON_USEDEP}]
	>=dev-python/webencodings-0.5.1[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2_pre20240221-py314.patch
)

EPYTEST_PLUGINS=( pytest-expect )
distutils_enable_tests pytest

src_prepare() {
	if use test; then
		mv "${WORKDIR}/${TEST_P}"/* html5lib/tests/testdata || die
	fi

	distutils-r1_src_prepare
}
