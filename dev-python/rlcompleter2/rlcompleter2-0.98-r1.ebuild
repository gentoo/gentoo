# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/rlcompleter2/rlcompleter2-0.98-r1.ebuild,v 1.1 2015/01/07 02:48:51 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python command line completion"
HOMEPAGE="http://codespeak.net/rlcompleter2/ http://pypi.python.org/pypi/rlcompleter2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

pkg_postinst() {
	ewarn "Please read the README, and follow instructions in order to"
	ewarn "execute and configure rlcompleter2."
}
