# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/ziproxy/ziproxy-3.3.0.ebuild,v 1.1 2013/01/08 16:19:56 jer Exp $

EAPI=4
inherit user

DESCRIPTION="A forwarding, non-caching, compressing web proxy server"
HOMEPAGE="http://ziproxy.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="jpeg2k sasl xinetd"

DEPEND="
	media-libs/giflib
	media-libs/libpng
	virtual/jpeg
	sys-libs/zlib
	jpeg2k? ( media-libs/jasper )
	sasl? ( dev-libs/cyrus-sasl )
"
RDEPEND="
	${DEPEND}
	xinetd? ( virtual/inetd )
"

pkg_setup() {
	enewgroup ziproxy
	enewuser ziproxy -1 -1 -1 ziproxy
}

src_prepare() {
	# fix sample config file
	sed -i \
		-e "s:/var/ziproxy/:/var/lib/ziproxy/:g" \
		-e "s:%j-%Y.log:/var/log/ziproxy/%j-%Y.log:g" \
		etc/ziproxy/ziproxy.conf || die

	# fix sample xinetd config
	sed -i \
		-e "s:/usr/bin/:/usr/sbin/:g" \
		-e "s:\(.*port.*\):\1\n\ttype\t\t\t= UNLISTED:g" \
		-e "s:root:ziproxy:g" \
		etc/xinetd.d/ziproxy || die
}

src_configure() {
	econf \
		$(use_with jpeg2k jasper) \
		$(use_with sasl sasl2) \
		--with-cfgfile=/etc/ziproxy/ziproxy.conf
}

src_install() {
	emake DESTDIR="${D}" install

	dodir /usr/sbin
	mv -vf "${D}"usr/{,s}bin/ziproxy || die

	dobin src/tools/ziproxy_genhtml_stats.sh

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	dodoc ChangeLog CREDITS README README.tools
	use jpeg2k && dodoc JPEG2000.txt

	insinto /etc
	doins -r etc/ziproxy

	insinto /var/lib/ziproxy/error
	doins var/ziproxy/error/*.html

	if use xinetd; then
		insinto /etc/xinetd.d
		doins etc/xinetd.d/ziproxy
	fi

	diropts -m0750 -o ziproxy -g ziproxy
	keepdir /var/log/ziproxy
}
