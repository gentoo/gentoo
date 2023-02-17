# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

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

PATCHES=(
	"${FILESDIR}/${P}-optional-extension.patch"
)

distutils_enable_tests pytest

python_test() {
	# skip tests of native extension for python versions where it is not available
	[[ ${EPYTHON} == python3.11 ]] && local -a EPYTEST_IGNORE=(
		"${S}/test/test_frozendict_c.py"
		"${S}/test/test_frozendict_c_subclass.py"
	)

	cd "${T}" || die
	epytest "${S}/test"
}
