# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libesmtp/libesmtp-1.0.6-r1.ebuild,v 1.3 2015/06/11 15:04:24 ago Exp $

EAPI=5
inherit libtool

DESCRIPTION="lib that implements the client side of the SMTP protocol"
HOMEPAGE="http://www.stafford.uklinux.net/libesmtp/"
SRC_URI="http://www.stafford.uklinux.net/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="debug ntlm ssl static-libs threads"

RDEPEND="ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}"

src_prepare() {
	elibtoolize
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable static-libs static) \
		--enable-all \
		$(use_enable ntlm) \
		$(use_enable threads pthreads) \
		$(use_enable debug) \
		$(use_with ssl openssl)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS Notes README TODO
	insinto /usr/share/doc/${PF}/xml
	doins doc/api.xml
}
