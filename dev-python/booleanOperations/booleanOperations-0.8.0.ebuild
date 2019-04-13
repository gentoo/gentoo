# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_6 )
inherit distutils-r1

DESCRIPTION="Boolean operations on paths"
HOMEPAGE="https://github.com/typemytype/booleanOperations"
SRC_URI="https://github.com/typemytype/booleanOperations/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/fonttools[${PYTHON_USEDEP}]
	dev-python/pyclipper[${PYTHON_USEDEP}]
	dev-python/ufoLib[${PYTHON_USEDEP}]
"

src_prepare() {
	export SETUPTOOLS_SCM_PRETEND_VERSION="${PV}"
	distutils-r1_src_prepare
}

python_test() {
	esetup.py test
}
