# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="A simple immutable mapping for python"
HOMEPAGE="
	https://github.com/Marco-Sulla/python-frozendict/
	https://pypi.org/project/frozendict/
"
SRC_URI="
	https://github.com/Marco-Sulla/python-frozendict/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/python-${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc64"

distutils_enable_tests pytest

python_compile() {
	# This prevents the build system from ignoring build failures, sigh.
	local -x CIBUILDWHEEL=1

	distutils-r1_python_compile
}

python_test() {
	rm -rf frozendict || die
	epytest
}
