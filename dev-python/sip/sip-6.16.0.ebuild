# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1

DESCRIPTION="Python bindings generator for C/C++ libraries"
HOMEPAGE="https://github.com/Python-SIP/sip/"
SRC_URI="
	https://github.com/Python-SIP/sip/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD-2 BSD"
SLOT="5"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools-scm-8[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	dev-python/myst-parser \
	dev-python/sphinx-rtd-theme

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	# the latest ABI version gets tested by default, but ABI 14
	# requires python3.15 or higher
	local epytestargs=()
	[[ ${EPYTHON} =~ python3.1[2-4]t? ]] &&
		epytestargs=( --sip-abi-version=13 )

	epytest "${epytestargs[@]}"
}
