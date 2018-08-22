# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_{5..7}} )

inherit distutils-r1

DESCRIPTION="Module for creating simple ASCII tables"
HOMEPAGE="https://github.com/foutaise/texttable"
SRC_URI="https://github.com/foutaise/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cjk test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		cjk? ( dev-python/cjkwrap[${PYTHON_USEDEP}] )
	)
"
RDEPEND="
	cjk? ( dev-python/cjkwrap[${PYTHON_USEDEP}] )
"

python_test() {
	py.test -v tests.py || die
}
