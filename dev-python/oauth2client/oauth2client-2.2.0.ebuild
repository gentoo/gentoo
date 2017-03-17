# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy)

inherit distutils-r1

DESCRIPTION="Library for accessing resources protected by OAuth 2.0"
HOMEPAGE="https://github.com/google/oauth2client"
SRC_URI="https://github.com/google/oauth2client/archive/v${PV/_p/-post}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	>=dev-python/httplib2-0.9.1[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-0.1.7[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-modules-0.0.5[${PYTHON_USEDEP}]
	>=dev-python/rsa-3.1.4[${PYTHON_USEDEP}]
	>=dev-python/six-1.6.1[${PYTHON_USEDEP}]
	!<=dev-python/google-api-python-client-1.1[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

S="${WORKDIR}"/${P/_p/-post}

# Needs network
RESTRICT=test

python_prepare_all() {
	sed -i \
		-e "s:find_packages():find_packages(exclude=['tests','tests.*']):" \
		setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests || die
}
