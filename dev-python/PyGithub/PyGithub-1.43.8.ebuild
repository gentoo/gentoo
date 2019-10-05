# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7} )

inherit distutils-r1

DESCRIPTION="Python library to access the Github API v3"
HOMEPAGE="https://github.com/PyGithub/PyGithub/"
# Use github since pypi is missing test data
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/deprecated[${PYTHON_USEDEP}]
	dev-python/pyjwt[${PYTHON_USEDEP}]
	>=dev-python/requests-2.14.0[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/cryptography[${PYTHON_USEDEP}]
		dev-python/httpretty[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	# tests requiring network access
	sed -i -e 's:testDecodeJson:_&:' tests/Issue142.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	# silly!
	cp -r tests "${BUILD_DIR}" || die
	if python_is_python3; then
		2to3 --no-diffs -n -w "${BUILD_DIR}"/tests || die
	fi

	cd "${BUILD_DIR}" || die
	"${EPYTHON}" -m unittest -v tests.AllTests || die "Tests fail with ${EPYTHON}"
}
