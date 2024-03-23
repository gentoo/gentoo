# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1

DESCRIPTION="multidict implementation"
HOMEPAGE="
	https://github.com/aio-libs/multidict/
	https://pypi.org/project/multidict/
"
SRC_URI="
	https://github.com/aio-libs/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"
IUSE="+native-extensions"

distutils_enable_tests pytest

python_prepare_all() {
	# don't enable coverage or other pytest settings
	sed -i -e '/cov/d' pyproject.toml pytest.ini || die
	distutils-r1_python_prepare_all
}

python_compile() {
	if ! use native-extensions || [[ ${EPYTHON} == pypy3 ]]; then
		local -x MULTIDICT_NO_EXTENSIONS=1
	fi

	distutils-r1_python_compile
}

python_test() {
	rm -rf multidict || die

	local cext=--c-extensions
	if ! use native-extensions || [[ ${EPYTHON} == pypy3 ]]; then
		cext=--no-c-extensions
	fi
	epytest "${cext}"
}
