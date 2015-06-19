# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/svg2rlg/svg2rlg-0.3.ebuild,v 1.8 2015/04/08 17:58:14 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="svg2rlg is a python tool to convert SVG files to reportlab
graphics"
HOMEPAGE="http://code.google.com/p/svg2rlg/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ppc ~ppc64 x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/reportlab[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}/${PN}-issue-3.patch" "${FILESDIR}/${PN}-issue-6.patch"
	"${FILESDIR}/${PN}-issue-7.patch")

python_test() {
	${EPYTHON} test_svg2rlg.py
}

python_prepare_all() {
	tmp=`mktemp` || die "mktemp failed"
	for i in `find -name '*.py'`; do
		tr -d '\r' < $i >$tmp  || die "tr failed"
		mv $tmp $i || die "mv failed"
	done

	distutils-r1_python_prepare_all
}
