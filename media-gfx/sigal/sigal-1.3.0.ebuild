# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="Simple static web gallery generator"
HOMEPAGE="http://sigal.saimon.org/"
SRC_URI="https://github.com/saimn/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="s3 test"
RESTRICT="!test? ( test )"

CDEPEND="dev-python/blinker[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pilkit[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}
	s3? ( dev-python/boto[${PYTHON_USEDEP}] )
	test? (
		dev-python/boto[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"
RDEPEND="${CDEPEND}"

DOCS="README.rst"

python_test() {
	esetup.py test
}
