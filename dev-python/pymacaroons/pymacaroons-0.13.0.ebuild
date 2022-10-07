# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1

DESCRIPTION="PyMacaroons is a Python implementation of Macaroons."
HOMEPAGE="
	https://github.com/ecordell/pymacaroons
	https://pypi.org/project/pymacaroons/
"
SRC_URI="https://github.com/ecordell/pymacaroons/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc64"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/pynacl[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)
"

python_test() {
	# The package also contains property_tests, however, they are incompatible
	# with dev-python/hypothesis in gentoo. The package requires too old version.
	"${EPYTHON}" -m nose -v tests/functional_tests || die "Tests failed with ${EPYTHON}"
}
