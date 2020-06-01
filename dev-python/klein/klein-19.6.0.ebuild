# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="micro-framework for developing production-ready web services with Python"
HOMEPAGE="https://pypi.org/project/klein https://github.com/twisted/klein"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/treq[${PYTHON_USEDEP}]
	)
"

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/hyperlink[${PYTHON_USEDEP}]
	dev-python/incremental[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/tubes[${PYTHON_USEDEP}]
	dev-python/twisted[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

python_prepare_all() {
	# nuke irreleveant test dep
	sed -e 's/"typing",//' \
		-i setup.py || die
	# known test fail: https://github.com/twisted/klein/issues/339
	sed -e 's/big world/big+world/' \
		-e 's/4321)]/4321.0)]/' \
		-e 's/not a number/not+a+number/' \
		-i src/klein/test/test_form.py  || die

	distutils-r1_python_prepare_all
}
python_test() {
	distutils_install_for_testing

	pytest -v ||
		die "Tests failed with ${EPYTHON}"
}
