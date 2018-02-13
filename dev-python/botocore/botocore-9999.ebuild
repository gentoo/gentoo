# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 python3_6 )

inherit distutils-r1

DESCRIPTION="Low-level, data-driven core of boto 3."
HOMEPAGE="https://github.com/boto/botocore"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="doc test"

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/boto/botocore"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
fi

RDEPEND="
	>=dev-python/docutils-0.10[${PYTHON_USEDEP}]
	>=dev-python/jmespath-0.7.1[${PYTHON_USEDEP}]
	<dev-python/jmespath-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.1[${PYTHON_USEDEP}]
	<dev-python/python-dateutil-3.0.0[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/guzzle_sphinx_theme-0.7.10[${PYTHON_USEDEP}]
		<dev-python/guzzle_sphinx_theme-0.8[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.3[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.7[${PYTHON_USEDEP}]
	)
	test? (
		${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/jsonschema[${PYTHON_USEDEP}]
	)
"

PATCHES=( "${FILESDIR}/1.8.6-tests-pass-all-env-vars-to-cmd-runner.patch" )

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	PYTHONPATH="${BUILD_DIR}/lib" nosetests -v tests/unit || die "unit tests failed under ${EPYTHON}"
	PYTHONPATH="${BUILD_DIR}/lib" nosetests -v tests/functional || die "functional tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )

	distutils-r1_python_install_all
}
