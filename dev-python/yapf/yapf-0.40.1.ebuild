# Copyright 2018-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

DESCRIPTION="A formatter for Python files"
HOMEPAGE="
	https://github.com/google/yapf/
	https://pypi.org/project/yapf/
"
SRC_URI="
	https://github.com/google/yapf/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/importlib-metadata-6.6.0[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-3.5.1[${PYTHON_USEDEP}]
	>=dev-python/tomli-2.0.1[${PYTHON_USEDEP}]
"

python_test() {
	"${EPYTHON}" -m unittest discover -v -p '*_test.py' ||
		die "Tests failed with ${EPYTHON}"
}
