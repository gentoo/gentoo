# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/googlecl/googlecl-0.9.14.ebuild,v 1.3 2013/02/21 15:07:40 zmedico Exp $

EAPI=3
PYTHON_DEPEND="2:2.5:2.7"

inherit distutils

DESCRIPTION="Command line tools for the Google Data APIs"
HOMEPAGE="http://code.google.com/p/googlecl/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~arm-linux ~x86-linux"
IUSE=""

DEPEND=""
RDEPEND="
	dev-python/gdata
"

pkg_setup() {
	python_set_active_version 2
}

src_install() {
	distutils_src_install

	dodoc changelog || die "dodoc failed"
	doman man/*.1 || die "doman failed"
}
