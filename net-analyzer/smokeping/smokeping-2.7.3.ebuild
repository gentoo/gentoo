# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools systemd tmpfiles user

DESCRIPTION="A powerful latency measurement tool"
HOMEPAGE="https://oss.oetiker.ch/smokeping/"
SRC_URI="https://oss.oetiker.ch/smokeping/pub/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="apache2 curl dig echoping ipv6 radius"

DEPEND="
	>=dev-lang/perl-5.8.8-r8
	>=dev-perl/SNMP_Session-1.13
	>=net-analyzer/fping-2.4_beta2-r2[suid]
	>=net-analyzer/rrdtool-1.2[graph,perl]
	dev-perl/CGI
	dev-perl/CGI-Session
	dev-perl/Config-Grammar
	dev-perl/Digest-HMAC
	dev-perl/FCGI
	dev-perl/IO-Socket-SSL
	dev-perl/IO-Tty
	dev-perl/Net-DNS
	dev-perl/Net-OpenSSH
	dev-perl/Net-SNMP
	dev-perl/Net-Telnet
	dev-perl/libwww-perl
	dev-perl/perl-ldap
	virtual/perl-libnet
	dev-perl/CGI-Fast
	!apache2? ( virtual/httpd-cgi )
	apache2? (
		>=www-apache/mod_perl-2.0.1
		www-apache/mod_fcgid
	)
	curl? ( >=net-misc/curl-7.21.4 )
	dig? ( net-dns/bind-tools )
	echoping? ( >=net-analyzer/echoping-6.0.2 )
	ipv6? ( >=dev-perl/Socket6-0.20 )
	radius? ( dev-perl/Authen-Radius )
"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup smokeping
	enewuser smokeping -1 -1 /var/lib/smokeping smokeping
}

src_prepare() {
	default

	sed -i -e '/^SUBDIRS = / s|thirdparty||g' Makefile.am || die
	sed -i -e '/^perllibdir = / s|= .*|= $(libdir)|g' lib/Makefile.am || die
	# bundled(?) dev-perl/SNMP_Session
	rm -r lib/{BER.pm,SNMP_Session.pm,SNMP_util.pm} || die
	echo ${PV} > VERSION || die

	eautoreconf
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
	dodir /usr/$(get_libdir)
	default

	newinitd "${FILESDIR}"/${PN}.init.5 ${PN}
	dotmpfiles "${FILESDIR}"/${PN}.conf
	systemd_dounit "${FILESDIR}"/${PN}.service

	mv "${ED}/etc/smokeping/basepage.html.dist" "${ED}/etc/smokeping/basepage.html" || die
	mv "${ED}/etc/smokeping/config.dist" "${ED}/etc/smokeping/config" || die
	mv "${ED}/etc/smokeping/smokemail.dist" "${ED}/etc/smokeping/smokemail" || die
	mv "${ED}/etc/smokeping/smokeping_secrets.dist" "${ED}/etc/smokeping/smokeping_secrets" || die
	mv "${ED}/etc/smokeping/tmail.dist" "${ED}/etc/smokeping/tmail" || die

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
		"${ED}/etc/${PN}/config" || die

	sed -i \
		-e '/^<script/{s:cropper/:/cropper/:}' \
		"${ED}/etc/${PN}/basepage.html" || die

	sed -i \
		-e 's/$FindBin::RealBin\/..\/etc\/config/\/etc\/smokeping\/config/g' \
		"${ED}/usr/bin/smokeping" "${ED}/usr/bin/smokeping_cgi" || die

	sed -i \
		-e 's:etc/config.dist:/etc/smokeping/config:' \
		"${ED}/usr/bin/tSmoke" || die

	sed -i \
		-e 's:/usr/etc/config:/etc/smokeping/config:' \
		"${ED}/var/www/localhost/smokeping/smokeping.fcgi.dist" || die

	dodir /var/www/localhost/cgi-bin
	mv "${ED}/var/www/localhost/smokeping/smokeping.fcgi.dist" \
		"${ED}/var/www/localhost/cgi-bin/smokeping.fcgi" || die

	fperms 700 /etc/${PN}/smokeping_secrets

	if use apache2 ; then
		insinto /etc/apache2/modules.d
		doins "${FILESDIR}/79_${PN}.conf"
	fi

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
	chown smokeping:smokeping "${EROOT}"/var/lib/${PN} || die
	chmod 755 "${EROOT}"/var/lib/${PN} || die
}
