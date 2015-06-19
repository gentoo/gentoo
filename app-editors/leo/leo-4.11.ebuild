# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/leo/leo-4.11.ebuild,v 1.5 2014/12/06 11:10:19 idella4 Exp $

EAPI="3"
PYTHON_DEPEND="2:2.6"
PYTHON_USE_WITH="tk"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 2.5 3.* *-pypy-* *-jython"

inherit distutils eutils

MY_P="Leo-${PV}-final"

DESCRIPTION="Leo: Literate Editor with Outlines"
HOMEPAGE="http://leo.sourceforge.net/ http://pypi.python.org/pypi/leo"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="app-text/silvercity
	dev-python/PyQt4[X]"

DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${MY_P}"

src_install() {
	distutils_src_install
	dohtml -r leo/doc/html/* || die "dohtml failed"
}
