# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/processing/processing-0.52-r1.ebuild,v 1.1 2015/02/16 15:02:56 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 flag-o-matic

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Package for using processes, which mimics the threading module API"
HOMEPAGE="http://pyprocessing.berlios.de/ http://pypi.python.org/pypi/processing"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND="app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${PYTHON_DEPS}"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	distutils-r1_src_prepare
	append-flags -fno-strict-aliasing
}
