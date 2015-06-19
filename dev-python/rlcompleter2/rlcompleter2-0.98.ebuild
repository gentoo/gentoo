# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/rlcompleter2/rlcompleter2-0.98.ebuild,v 1.5 2012/02/22 07:30:21 patrick Exp $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils

DESCRIPTION="Python command line completion"
HOMEPAGE="http://codespeak.net/rlcompleter2/ http://pypi.python.org/pypi/rlcompleter2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc x86"
IUSE=""

DEPEND=""
RDEPEND=""

PYTHON_MODNAME="rlcompleter2.py"

pkg_postinst() {
	ewarn "Please read the README, and follow instructions in order to"
	ewarn "execute and configure rlcompleter2."
}
