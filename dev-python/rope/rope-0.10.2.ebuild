# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/rope/rope-0.10.2.ebuild,v 1.3 2015/04/08 08:05:07 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python refactoring library"
HOMEPAGE="http://rope.sourceforge.net/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

python_test() {
	PYTHONPATH="${BUILD_DIR}/lib:." ${EPYTHON} ropetest/__init__.py
}

src_install() {
	distutils-r1_src_install
	docinto docs
	dodoc docs/*.rst
}
