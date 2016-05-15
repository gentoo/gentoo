# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Google API Client for Python"
HOMEPAGE="https://code.google.com/p/google-api-python-client/ https://github.com/google/google-api-python-client"
SRC_URI="https://github.com/google/google-api-python-client/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"

RDEPEND="
	>=dev-python/httplib2-0.8[${PYTHON_USEDEP}]
	<dev-python/httplib2-1[${PYTHON_USEDEP}]
	>=dev-python/oauth2client-2[${PYTHON_USEDEP}]
	<dev-python/oauth2client-3[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/uritemplate-0.6[${PYTHON_USEDEP}]
	<dev-python/uritemplate-1[${PYTHON_USEDEP}]
	>=dev-python/six-1.6.1[${PYTHON_USEDEP}]
	<dev-python/six-2[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
	)"

python_prepare_all(){
	export SKIP_GOOGLEAPICLIENT_COMPAT_CHECK=true
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests --verbosity=3 || die
}
