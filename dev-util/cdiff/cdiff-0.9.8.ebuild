# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy )

inherit distutils-r1

DESCRIPTION="Colored, side-by-side diff terminal viewer"
HOMEPAGE="https://github.com/ymattw/${PN}"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	!<app-misc/colordiff-1.0.13-r1
	dev-python/setuptools[${PYTHON_USEDEP}]
	sys-apps/less"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-0.9.2-disable-unimportant-failing-test.patch )

DOCS=( CHANGES.rst README.rst )

python_test() {
	${PYTHON} tests/test_cdiff.py || die "Unit tests failed."

	./tests/regression.sh || die "Regression tests failed."
}
