# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/configobj/configobj-5.0.6.ebuild,v 1.2 2015/07/29 19:15:16 grobian Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Simple config file reader and writer"
HOMEPAGE="http://www.voidspace.org.uk/python/configobj.html http://code.google.com/p/configobj/ http://pypi.python.org/pypi/configobj"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"

python_prepare_all() {
	# Not to install un-needed _version.py
	sed -e "/^MODULES =/s/, '_version'//" -i setup.py
	sed -e "s/^from _version import __version__$/__version__ = '${PV}'/" -i configobj.py

	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" validate.py -v || die "Tests fail with ${EPYTHON}"
}
