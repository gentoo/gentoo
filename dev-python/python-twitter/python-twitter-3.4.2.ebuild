# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Python wrapper around the Twitter API"
HOMEPAGE="https://github.com/bear/python-twitter"
# Upstream does not include tests or doc in the PyPI tarballs
# https://github.com/bear/python-twitter/pull/572
SRC_URI="https://github.com/bear/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-macos"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

# https://bugs.gentoo.org/624916
RDEPEND="
	!dev-python/twitter
	dev-python/oauth2[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/requests-oauthlib[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		>=dev-python/responses-0.6.1[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	# Not actually required unless we want to do setup.py test
	# https://github.com/bear/python-twitter/pull/573
	sed -i "s/'pytest-runner'//" setup.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		sphinx-build doc doc/_build/html || die
		HTML_DOCS=( doc/_build/html/. )
	fi
}

python_test() {
	py.test || die "tests failed with ${EPYTHON}"
}

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r examples/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}
