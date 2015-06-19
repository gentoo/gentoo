# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/smokeping/smokeping-2.6.9.ebuild,v 1.11 2014/08/10 21:00:44 slyfox Exp $

EAPI=5
inherit eutils user systemd

DESCRIPTION="A powerful latency measurement tool"
HOMEPAGE="http://oss.oetiker.ch/smokeping/"
SRC_URI="http://oss.oetiker.ch/smokeping/pub/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
# dropping hppa and sparc because of way too may dependencies not having
# keywords in those architectures.
KEYWORDS="amd64 ~hppa x86"

# removing fcgi useflag as the configure script can't avoid it without patching
IUSE="apache2 curl dig echoping ipv6 ldap radius ssh telnet"

DEPEND="
	!apache2? ( virtual/httpd-cgi )
	apache2? (
		>=www-apache/mod_perl-2.0.1
		www-apache/mod_fcgid
	)
	curl? ( >=net-misc/curl-7.21.4 )
	dig? ( net-dns/bind-tools )
	echoping? ( >=net-analyzer/echoping-6.0.2 )
	ipv6? ( >=dev-perl/Socket6-0.20 )
	ldap? ( dev-perl/perl-ldap )
	radius? ( dev-perl/RadiusPerl )
	ssh? ( dev-perl/Net-OpenSSH )
	telnet? ( dev-perl/Net-Telnet )
	>=dev-lang/perl-5.8.8-r8
	>=dev-perl/SNMP_Session-1.13
	>=net-analyzer/fping-2.4_beta2-r2[suid]
	>=net-analyzer/rrdtool-1.2[graph,perl]
	dev-perl/CGI-Session
	dev-perl/Config-Grammar
	dev-perl/Digest-HMAC
	dev-perl/FCGI
	dev-perl/IO-Socket-SSL
	dev-perl/Net-DNS
	dev-perl/libwww-perl
	virtual/perl-libnet
"

RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup smokeping
	enewuser smokeping -1 -1 /var/lib/smokeping smokeping
}

src_prepare() {
	rm -r lib/{BER.pm,SNMP_Session.pm,SNMP_util.pm} # dev-perl/SNMP_Session

	epatch "${FILESDIR}"/${P}-pod.patch
}

src_configure() {
	econf \
		--sysconfdir=/etc/smokeping \
		--with-htdocs-dir=/var/www/localhost/smokeping
}

src_compile() {
	LC_ALL=C emake
}

src_install() {
	default

	newinitd "${FILESDIR}/${PN}.init.3" ${PN}
	systemd_dotmpfilesd "${FILESDIR}"/"${PN}".conf
	systemd_dounit "${FILESDIR}"/"${PN}".service

	mv "${D}/etc/smokeping/basepage.html.dist" "${D}/etc/smokeping/basepage.html"
	mv "${D}/etc/smokeping/config.dist" "${D}/etc/smokeping/config"
	mv "${D}/etc/smokeping/smokemail.dist" "${D}/etc/smokeping/smokemail"
	mv "${D}/etc/smokeping/smokeping_secrets.dist" "${D}/etc/smokeping/smokeping_secrets"
	mv "${D}/etc/smokeping/tmail.dist" "${D}/etc/smokeping/tmail"

	sed -i \
		-e '/^imgcache/{s:\(^imgcache[ \t]*=\).*:\1 /var/lib/smokeping/.simg:}' \
		-e '/^imgurl/{s:\(^imgurl[ \t]*=\).*:\1 ../.simg:}' \
		-e '/^datadir/{s:\(^datadir[ \t]*=\).*:\1 /var/lib/smokeping:}' \
		-e '/^piddir/{s:\(^piddir[ \t]*=\).*:\1 /run/smokeping:}' \
	    -e '/^cgiurl/{s#\(^cgiurl[ \t]*=\).*#\1 http://some.place.xyz/perl/smokeping.pl#}' \
		-e '/^smokemail/{s:\(^smokemail[ \t]*=\).*:\1 /etc/smokeping/smokemail:}' \
		-e '/^tmail/{s:\(^tmail[ \t]*=\).*:\1 /etc/smokeping/tmail:}' \
		-e '/^secrets/{s:\(^secrets[ \t]*=\).*:\1 /etc/smokeping/smokeping_secrets:}' \
		-e '/^template/{s:\(^template[ \t]*=\).*:\1 /etc/smokeping/basepage.html:}' \
		"${D}/etc/${PN}/config" || die

	sed -i \
		-e '/^<script/{s:cropper/:/cropper/:}' \
		"${D}/etc/${PN}/basepage.html" || die

	sed -i \
		-e 's/$FindBin::Bin\/..\/etc\/config/\/etc\/smokeping\/config/g' \
		"${D}/usr/bin/smokeping" "${D}/usr/bin/smokeping_cgi" || die

	sed -i \
		-e 's:etc/config.dist:/etc/smokeping/config:' \
		"${D}/usr/bin/tSmoke" || die

	sed -i \
		-e 's:/usr/etc/config:/etc/smokeping/config:' \
		"${D}/var/www/localhost/smokeping/smokeping.fcgi.dist" || die

	dodir /var/www/localhost/cgi-bin
		mv "${D}/var/www/localhost/smokeping/smokeping.fcgi.dist" \
		"${D}/var/www/localhost/cgi-bin/smokeping.fcgi"

	fperms 700 /etc/${PN}/smokeping_secrets

	if use apache2 ; then
		insinto /etc/apache2/modules.d
		doins "${FILESDIR}/79_${PN}.conf"
	fi

	dodir /var/cache/smokeping
	keepdir /var/cache/smokeping

	# Create the files in /var for rrd file storage
	keepdir /var/lib/${PN}/.simg
	fowners smokeping:smokeping /var/lib/${PN}

	if use apache2 ; then
		fowners apache:apache /var/lib/${PN}/.simg
		fowners -R apache:apache /var/www
	else
		fowners smokeping:smokeping /var/lib/${PN}/.simg
	fi

	fperms 775 /var/lib/${PN} /var/lib/${PN}/.simg
}

pkg_postinst() {
	chown smokeping:smokeping "${ROOT}/var/lib/${PN}"
	chmod 755 "${ROOT}/var/lib/${PN}"
}
