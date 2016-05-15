# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="MailDir mailbox synchronizer"
HOMEPAGE="http://isync.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="compat sasl libressl ssl zlib"

DEPEND=">=sys-libs/db-4.2:*
	zlib? ( sys-libs/zlib )
	sasl? ( dev-libs/cyrus-sasl )
	ssl? (
	    !libressl? ( >=dev-libs/openssl-0.9.6:* )
	    libressl? ( dev-libs/libressl )
	)"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		--docdir="/usr/share/doc/${PF}" \
		$(use_with ssl) \
		$(use_with sasl) \
		$(use_with zlib) \
		$(use_enable compat)
}
