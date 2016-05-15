# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="Google API Client for Python"
HOMEPAGE="https://code.google.com/p/google-api-python-client/ https://github.com/google/google-api-python-client"
SRC_URI="https://github.com/google/google-api-python-client/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

DEPEND="
	dev-python/python-gflags[${PYTHON_USEDEP}]
	>=dev-python/httplib2-0.8[${PYTHON_USEDEP}]
	<dev-python/oauth2client-2[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/uritemplate[${PYTHON_USEDEP}]
	"
RDEPEND="${DEPEND}"

python_prepare_all(){
	export SKIP_GOOGLEAPICLIENT_COMPAT_CHECK=true
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests --verbosity=3 || die
}
