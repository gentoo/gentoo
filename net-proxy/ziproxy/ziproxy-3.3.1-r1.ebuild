# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit user

DESCRIPTION="A forwarding, non-caching, compressing web proxy server"
HOMEPAGE="http://ziproxy.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="sasl xinetd"

RDEPEND="
	media-libs/giflib:0=
	media-libs/libpng:0=
	virtual/jpeg:0
	sys-libs/zlib
	sasl? ( dev-libs/cyrus-sasl )
	xinetd? ( virtual/inetd )
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-giflib5.patch )

pkg_setup() {
	enewgroup ziproxy
	enewuser ziproxy -1 -1 -1 ziproxy
}

src_prepare() {
	default

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
		--without-jasper \
		$(use_with sasl sasl2) \
		--with-cfgfile=/etc/ziproxy/ziproxy.conf
}

src_install() {
	default

	dodir /usr/sbin
	mv -vf "${D}"usr/{,s}bin/ziproxy || die

	dobin src/tools/ziproxy_genhtml_stats.sh

	newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

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
