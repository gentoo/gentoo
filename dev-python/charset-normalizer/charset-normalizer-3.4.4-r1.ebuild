# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 8 -- sys-apps/portage dep
EAPI=8

DISTUTILS_USE_PEP517=standalone
DISTUTILS_EXT=1
PYPI_VERIFY_REPO=https://github.com/jawah/charset_normalizer
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="The Real First Universal Charset Detector"
HOMEPAGE="
	https://pypi.org/project/charset-normalizer/
	https://github.com/jawah/charset_normalizer/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos"
IUSE="+native-extensions"

BDEPEND="
	native-extensions? (
		$(python_gen_cond_dep '
			dev-python/mypy[${PYTHON_USEDEP}]
		' python3.{11..14})
	)
	dev-python/setuptools[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_compile() {
	local -x CHARSET_NORMALIZER_USE_MYPYC=$(usex native-extensions 1 0)

	distutils-r1_python_compile
}

python_test() {
	epytest -o addopts=
}
