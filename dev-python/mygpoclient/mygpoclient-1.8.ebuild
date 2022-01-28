# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="A gpodder.net client library"
HOMEPAGE="https://github.com/gpodder/mygpoclient
	https://mygpoclient.readthedocs.io/en/latest/"
SRC_URI="https://github.com/gpodder/mygpoclient/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="test? ( dev-python/minimock[${PYTHON_USEDEP}] )"

PATCHES=(
	"${FILESDIR}"/${P}-fix-literal.patch
	"${FILESDIR}"/${PN}-1.8-tests.patch
)

distutils_enable_tests nose

src_prepare() {
	# Disable tests requring network connection.
	rm mygpoclient/http_test.py || die

	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install
	find "${D}" -name "*_test.py" -delete || die
}
