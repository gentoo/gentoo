# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_{6,7}} )

inherit distutils-r1 eutils

DESCRIPTION="A gpodder.net client library"
HOMEPAGE="https://github.com/gpodder/mygpoclient
	https://mygpoclient.readthedocs.io/en/latest/"
SRC_URI="https://github.com/gpodder/mygpoclient/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/simplejson[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/minimock
	)
"

PATCHES=( "${FILESDIR}"/${P}-tests.patch )

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
