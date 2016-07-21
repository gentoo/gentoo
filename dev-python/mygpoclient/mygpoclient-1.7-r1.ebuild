# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1 eutils

DESCRIPTION="A gpodder.net client library"
HOMEPAGE="http://thp.io/2010/mygpoclient/"
SRC_URI="http://thp.io/2010/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="dev-python/simplejson"
DEPEND="${RDEPEND}
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/minimock
	)"

PATCHES=( "${FILESDIR}"/tests.patch )

src_prepare() {
	distutils-r1_src_prepare
	# Disable tests requring network connection.
	rm -f mygpoclient/http_test.py
}

python_test() {
	if [[ "${EPYTHON:0:4}" == "pypy" ]]; then
		nosetests --cover-erase --with-coverage --cover-package=mygpoclient "${BUILD_DIR}"/lib/${PN}/
	else
		nosetests --cover-erase --with-coverage --with-doctest --cover-package=mygpoclient "${BUILD_DIR}"/lib/${PN}/
	fi
}

src_install() {
	distutils-r1_src_install
	rm -f $(find "${D}" -name "*_test.py")
}
