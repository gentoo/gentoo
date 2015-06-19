# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/ropeide/ropeide-1.5.1-r2.ebuild,v 1.1 2015/01/07 02:59:28 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1
PYTHON_REQ_USE="tk"

DESCRIPTION="Python refactoring IDE"
HOMEPAGE="http://rope.sourceforge.net/ropeide.html http://pypi.python.org/pypi/ropeide"
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
