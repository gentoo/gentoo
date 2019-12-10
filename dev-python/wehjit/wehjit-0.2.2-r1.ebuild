# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A Python web-widget library"
HOMEPAGE="http://jderose.fedorapeople.org/wehjit"
SRC_URI="http://jderose.fedorapeople.org/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/genshi
		dev-python/assets[${PYTHON_USEDEP}]
		dev-python/paste[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		"
DEPEND="${RDEPEND}"

DOCS=( README NEWS )

PATCHES=( "${FILESDIR}"/${P}-SkipTest.patch )

python_test() {
	if [[ "${EPYTHON:6:3}" == '2.6' ]]; then
		nosetests -I test_app* -e=*getitem
	else
		nosetests
	fi
}
