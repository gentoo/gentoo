# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1
PYTHON_REQ_USE="tk"

DESCRIPTION="Python refactoring IDE"
HOMEPAGE="http://rope.sourceforge.net/ropeide.html https://pypi.python.org/pypi/ropeide"
SRC_URI="mirror://sourceforge/rope/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=">=dev-python/rope-0.8.4[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_install_all() {
	if use doc; then
		dodoc docs/*.txt || die "dodoc failed"
	fi
	distutils-r1_python_install_all
}
