# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy )

inherit distutils-r1

DESCRIPTION="Simple config file reader and writer"
HOMEPAGE="http://www.voidspace.org.uk/python/configobj.html https://code.google.com/p/configobj/ https://pypi.python.org/pypi/configobj"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"

python_prepare_all() {
	# Not to install un-needed _version.py
	sed -e "/^MODULES =/s/, '_version'//" -i setup.py || die
	sed \
		-e "s/^from _version import __version__$/__version__ = '${PV}'/" \
		-i configobj.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" validate.py -v || die "Tests fail with ${EPYTHON}"
}
