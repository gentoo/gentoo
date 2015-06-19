# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/configobj/configobj-4.7.2-r2.ebuild,v 1.9 2015/04/08 08:05:27 mgorny Exp $

EAPI="5"

PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1 eutils

DESCRIPTION="Simple config file reader and writer"
HOMEPAGE="http://www.voidspace.org.uk/python/configobj.html http://code.google.com/p/configobj/ http://pypi.python.org/pypi/configobj"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND=""

PATCHES=( "${FILESDIR}"/${P}-fix_tests.patch )

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -e "s/ \(doctest\.testmod(.*\)/ sys.exit(\1[0] != 0)/" -i validate.py || die
}

python_test() {
	"${PYTHON}" validate.py -v || die
}

python_install_all() {
	distutils-r1_python_install_all
	if use doc; then
		rm -f docs/BSD*
		insinto /usr/share/doc/${PF}/html
		doins -r docs/* || die "doins failed"
	fi
}
