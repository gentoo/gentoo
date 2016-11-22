# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Mailfilter is a utility to get rid of unwanted spam mails"
HOMEPAGE="http://mailfilter.sourceforge.net/"
SRC_URI="mirror://sourceforge/mailfilter/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE="+ssl"

DEPEND="sys-devel/flex
	ssl? ( dev-libs/openssl:* )"
RDEPEND=""

src_configure() {
	econf $(use_with ssl openssl)
}

src_install() {
	default
	dodoc INSTALL doc/FAQ "${FILESDIR}"/rcfile.example{1,2}
}
