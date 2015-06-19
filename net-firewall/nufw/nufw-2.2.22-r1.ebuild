# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/nufw/nufw-2.2.22-r1.ebuild,v 1.4 2014/12/28 16:20:25 titanofold Exp $

EAPI=5

SSL_CERT_MANDATORY=1
inherit autotools eutils multilib pam ssl-cert

DESCRIPTION="An enterprise grade authenticating firewall based on netfilter"
HOMEPAGE="http://www.nufw.org/"
SRC_URI="http://www.nufw.org/attachments/download/39/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="debug ldap mysql pam pam_nuauth plaintext postgres prelude unicode nfqueue nfconntrack static syslog test"

REQUIRED_USE="pam_nuauth? ( plaintext )"
DEPEND="
	dev-libs/cyrus-sasl
	dev-libs/glib:2
	dev-libs/libgcrypt:0
	dev-python/ipy
	net-firewall/iptables
	net-libs/gnutls
	ldap? ( >=net-nds/openldap-2 )
	mysql? ( virtual/mysql )
	nfconntrack? ( net-libs/libnetfilter_conntrack )
	nfqueue? ( net-libs/libnfnetlink net-libs/libnetfilter_queue )
	pam? ( sys-libs/pam )
	pam_nuauth? ( sys-libs/pam )
	postgres? ( dev-db/postgresql[server] )
	prelude? ( dev-libs/libprelude )
"
RDEPEND=${DEPEND}

RESTRICT="test"

src_prepare() {
	epatch "${FILESDIR}"/${P}-var-run.patch
	sed -i \
		-e 's:^#\(nuauth_tls_key="/etc/nufw/\)nuauth-key.pem:\1nuauth.key:' \
		-e 's:^#\(nuauth_tls_cert="/etc/nufw/\)nuauth-cert.pem:\1nuauth.pem:' \
		conf/nuauth.conf || die
	sed -i \
		-e "/^modulesdir/s|=.*|= /$(get_libdir)/security|g" \
		src/clients/pam_nufw/Makefile.am || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable pam_nuauth pam-nufw) \
		$(use_enable static) \
		$(use_with ldap) \
		$(use_with mysql mysql-auth) \
		$(use_with mysql mysql-log) \
		$(use_with nfconntrack) \
		$(use_with nfqueue) \
		$(use_with pam system-auth) \
		$(use_with plaintext plaintext-auth) \
		$(use_with postgres pgsql-log) \
		$(use_with prelude prelude-log) \
		$(use_with syslog syslog-log) \
		$(use_with unicode utf8) \
		--enable-shared \
		--includedir="/usr/include/nufw" \
		--localstatedir="/var" \
		--sysconfdir="/etc/nufw" \
		--with-mark-group \
		--with-user-mark
}

src_install() {
	default

	newinitd "${FILESDIR}"/nufw-init.d nufw
	newconfd "${FILESDIR}"/nufw-conf.d nufw

	newinitd "${FILESDIR}"/nuauth-init.d nuauth
	newconfd "${FILESDIR}"/nuauth-conf.d nuauth

	insinto /etc/nufw
	doins conf/nuauth.conf

	dodoc AUTHORS ChangeLog NEWS README TODO
	docinto scripts
	dodoc scripts/{clean_conntrack.pl,nuaclgen,nutop,README,ulog_rotate_daily.sh,ulog_rotate_weekly.sh}
	docinto conf
	dodoc conf/*.{nufw,schema,conf,dump,xml}

	if use pam; then
		pamd_mimic system-auth nufw auth account password session
	fi

	prune_libtool_files
}

pkg_postinst() {
	install_cert /etc/nufw/{nufw,nuauth}
}
