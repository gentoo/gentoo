# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Pure Python CBOR (de)serializer with extensive tag support"
HOMEPAGE="
	https://github.com/agronholm/cbor2/
	https://pypi.org/project/cbor2/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc64 ~riscv ~s390 ~sparc x86"

BDEPEND="
	>=dev-python/setuptools-61[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-6.4[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_prepare_all() {
	# remove pytest-cov dep
	sed -i -e "s/--cov//" pyproject.toml || die
	distutils-r1_python_prepare_all
}

python_compile() {
	local -x CBOR2_BUILD_C_EXTENSION=1
	# pypy3 not supported upstream
	# py3.12: https://github.com/agronholm/cbor2/issues/171
	if has "${EPYTHON}" pypy3 python3.12; then
		CBOR2_BUILD_C_EXTENSION=0
	fi
	distutils-r1_python_compile
}
