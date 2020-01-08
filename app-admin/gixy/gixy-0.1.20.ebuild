# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="Nginx configuration static analyzer"
HOMEPAGE="https://github.com/yandex/gixy"
# Use GitHub source insted PyPi to get tarball with tests
SRC_URI="https://github.com/yandex/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-python/pyparsing-1.5.5[${PYTHON_USEDEP}]
	>=dev-python/cached-property-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/configargparse-0.11.0[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.8[${PYTHON_USEDEP}]
	>=dev-python/six-1.1.0[${PYTHON_USEDEP}]"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		${RDEPEND}
	)
"

python_prepare() {
	sed -i -e "/argparse/d" setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests -v || die
}
