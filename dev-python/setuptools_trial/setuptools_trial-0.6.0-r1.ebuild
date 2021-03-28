# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )

DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="Setuptools plugin that makes unit tests execute with trial instead of pyunit"
HOMEPAGE="https://github.com/rutsky/setuptools-trial https://pypi.org/project/setuptools_trial/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/twisted-16.0.0[${PYTHON_USEDEP}]
"

BDEPEND="${RDEPEND}"

python_test() {
	distutils_install_for_testing

	# The pkg test suite creates a virtualenv to install to for testing
	# The distutils-r1 eclass already does the equivalent for us.
	# So just run the same commands they do directly...
	pushd "${S}"/tests/dummy_project > /dev/null || die
	"${EPYTHON}" -m setup.py trial || \
			die "trial tests failed with ${EPYTHON}"
	"${EPYTHON}" -m setup.py trial --reporter=text || \
			die "trial --reporter tests failed with ${EPYTHON}"
	popd > /dev/null || die
	pushd "${S}"/tests/alias_project > /dev/null || die
	"${EPYTHON}" -m setup.py test || \
			die "alias_project tests failed with ${EPYTHON}"
	popd > /dev/null || die
}
