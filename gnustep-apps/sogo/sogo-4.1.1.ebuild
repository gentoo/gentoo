# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnustep-2 user vcs-snapshot

DESCRIPTION="Groupware server built around OpenGroupware.org and the SOPE application server"
HOMEPAGE="http://www.sogo.nu"
SRC_URI="https://github.com/inverse-inc/sogo/archive/SOGo-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="activesync gnutls libressl +ssl"

RDEPEND="
	dev-libs/libmemcached
	net-misc/curl
	net-misc/memcached
	>=gnustep-libs/sope-${PV}[ldap]
	activesync? ( dev-libs/libwbxml )
	gnutls? ( net-libs/gnutls:= )
	!gnutls? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:= )
	)
"
DEPEND="${RDEPEND}
	>=gnustep-base/gnustep-make-2.6.3"

pkg_pretend() {
	if use ssl && use gnutls && use libressl ; then
		ewarn "You have enabled both gnutls and libressl, but only"
		ewarn "one provider can be active. Using gnutls!"
	fi
}

pkg_setup() {
	enewgroup sogo
	enewuser sogo -1 /bin/bash /var/lib/sogo sogo
}

src_prepare() {
	gnustep-base_src_prepare
	sed -e "s/validateArgs$//" -i configure \
		|| die
	if use activesync; then
		sed -e 's/Tests\/Unit/ActiveSync &/g' \
			-i GNUmakefile || die
	fi

	default
}

src_configure() {
	local ssl_provider
	if use ssl ; then
		if use gnutls ; then
			ssl_provider=gnutls
		else
			ssl_provider=ssl
		fi
	else
		ssl_provider=none
	fi

	egnustep_env

	./configure \
		--disable-strip \
		--prefix=/usr \
		--with-ssl="${ssl_provider}" \
		$(use_enable debug) \
		|| die "configure failed"
}

src_install() {
	gnustep-base_src_install

	newconfd "${FILESDIR}"/sogod.confd sogod
	newinitd "${FILESDIR}"/sogod.initd sogod

	insinto /etc/logrotate.d
	newins Scripts/logrotate sogo
	newdoc Apache/SOGo.conf SOGo-Apache.conf

	insinto /etc/sogo
	doins Scripts/sogo.conf

	insinto /etc/cron.d
	newins Scripts/sogo.cron sogo
	keepdir /var/log/sogo

	fowners sogo:sogo /var/log/sogo
	fowners -R root:sogo /etc/sogo
}

pkg_postinst() {
	gnustep-base_pkg_postinst
	elog "SOGo documentation is available online at:"
	elog "http://www.sogo.nu/downloads/documentation.html"
	elog
	elog "Apache sample configuration file is available in:"
	elog "/usr/share/doc/${PF}"
	if use activesync; then
		ewarn "In order to use the SOGo ActiveSync support code in production environments,"
		ewarn "you need to get a proper usage license. Check the documentation for details."
	fi
}
