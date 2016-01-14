# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="python tool to convert SVG files to reportlab graphics"
HOMEPAGE="https://code.google.com/p/svg2rlg/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ppc ppc64 sparc x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/reportlab[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/${PN}-issue-3.patch"
	"${FILESDIR}/${PN}-issue-6.patch"
	"${FILESDIR}/${PN}-issue-7.patch"
)

python_test() {
	${EPYTHON} test_svg2rlg.py
}

python_prepare_all() {
	find -name '*.py' -exec sed -i 's:\r::' {} + || die

	distutils-r1_python_prepare_all
}
