# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
C_EXT_COMPAT=( python3.{9..10} )

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
KEYWORDS="~amd64 ~ppc64"

distutils_enable_tests pytest

python_compile() {
	local -x CIBUILDWHEEL=0
	# This prevents the build system from ignoring build failures, sigh.
	has "${EPYTHON}" "${C_EXT_COMPAT[@]}" && CIBUILDWHEEL=1

	distutils-r1_python_compile
}

python_test() {
	local EPYTEST_IGNORE=()
	# skip tests of native extension for python versions where it is not available
	if ! has "${EPYTHON}" "${C_EXT_COMPAT[@]}"; then
		EPYTEST_IGNORE+=(
			test/test_frozendict_c.py
			test/test_frozendict_c_subclass.py
		)
	fi

	rm -rf frozendict || die
	epytest
}
