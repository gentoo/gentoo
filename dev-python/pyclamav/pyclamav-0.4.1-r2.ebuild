# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyclamav/pyclamav-0.4.1-r2.ebuild,v 1.1 2015/02/17 08:50:08 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python binding for libclamav"
HOMEPAGE="http://xael.org/norman/python/pyclamav/ http://pypi.python.org/pypi/pyclamav"
SRC_URI="http://xael.org/norman/python/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
IUSE=""

DEPEND=">=app-antivirus/clamav-0.90"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-clamav-0.95.patch )
DOCS=( README.txt  example.py )

src_install() {
	distutils-r1_src_install

	insinto /usr/share/doc/${PF}
	doins example.py
}

pkg_postinst() {
	elog "an example called example.py has been installed into /usr/share/doc/${PF}"
}
