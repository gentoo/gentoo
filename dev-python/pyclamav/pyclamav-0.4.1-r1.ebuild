# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython *-pypy-*"

inherit distutils eutils

DESCRIPTION="Python binding for libclamav"
HOMEPAGE="http://xael.org/norman/python/pyclamav/ https://pypi.python.org/pypi/pyclamav"
SRC_URI="http://xael.org/norman/python/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc x86"
IUSE=""

DEPEND=">=app-antivirus/clamav-0.90"
RDEPEND="${DEPEND}"

src_prepare() {
	distutils_src_prepare

	# Patch from Debian to build w/ >=clamav-0.95
	epatch "${FILESDIR}/${P}-clamav-0.95.patch"
}

src_install() {
	distutils_src_install

	insinto /usr/share/doc/${PF}
	doins example.py
}
