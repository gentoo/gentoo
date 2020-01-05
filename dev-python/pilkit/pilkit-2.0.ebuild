# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="A collection of utilities and processors for the Python Imaging Libary"
HOMEPAGE="https://github.com/matthewwithanm/pilkit"
SRC_URI="https://github.com/matthewwithanm/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND="dev-python/pillow[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)"
RDEPEND="${CDEPEND}"

python_test() {
	nosetests --verbose || die
}
