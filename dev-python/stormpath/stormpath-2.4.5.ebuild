# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Official Stormpath SDK, used to interact with the Stormpath REST API."
HOMEPAGE="https://github.com/stormpath/stormpath-sdk-python"
SRC_URI="https://github.com/stormpath/${PN}-sdk-python/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	>=dev-python/isodate-0.5.4[${PYTHON_USEDEP}]
	<=dev-python/oauthlib-1.0.3[${PYTHON_USEDEP}]
	>=dev-python/pydispatcher-2.0.5[${PYTHON_USEDEP}]
	>=dev-python/pyjwt-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.4.3[${PYTHON_USEDEP}]
	>=dev-python/six-1.6.1[${PYTHON_USEDEP}]
"

python_compile_all() {
	esetup.py docs
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )

	distutils-r1_python_install_all
}
