# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="Patch-like tool for applying diffs which can resolve common causes of patch rejects"
HOMEPAGE="http://oss.oracle.com/~mason/mpatch/"
SRC_URI="http://oss.oracle.com/~mason/mpatch/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""

DEPEND=""
RDEPEND=""

pkg_setup() {
	python-single-r1_pkg_setup
}

src_install() {
	distutils-r1_src_install
	dobin cmd/qp cmd/mp
}
