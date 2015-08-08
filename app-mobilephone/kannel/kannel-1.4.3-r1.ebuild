# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
WANT_AUTOMAKE=none

inherit eutils autotools flag-o-matic ssl-cert user

DESCRIPTION="Powerful SMS and WAP gateway"
HOMEPAGE="http://www.kannel.org/"
SRC_URI="http://www.kannel.org/download/${PV}/gateway-${PV}.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="ssl mysql sqlite postgres pcre doc debug pam"

RESTRICT="test" # some tests fail with "address already in use"

RDEPEND="sys-libs/e2fsprogs-libs
	dev-libs/libxml2
	dev-lang/perl
	sys-libs/zlib
	ssl? ( dev-libs/openssl )
	mysql? ( virtual/mysql )
	sqlite? ( dev-db/sqlite:3 )
	postgres? ( dev-db/postgresql[server] )
	pcre? ( dev-libs/libpcre )
	pam? ( virtual/pam )"
DEPEND="${RDEPEND}
	>=sys-devel/bison-2.2
	doc? ( media-gfx/transfig
		app-text/jadetex
		app-text/docbook-dsssl-stylesheets
		app-text/docbook-sgml-dtd:3.1 )"

S="${WORKDIR}/gateway-${PV}"

pkg_setup() {
	enewgroup kannel
	enewuser kannel -1 -1 /var/log/kannel kannel
}

src_prepare() {
	epatch "${FILESDIR}/${P}-custom-wap-ports.patch"
	epatch "${FILESDIR}/${P}-autotools.patch"
	epatch "${FILESDIR}/${P}-external-libuuid.patch"

	#by default, use current directory for logging
	sed -i -e 's:/tmp/::' doc/examples/kannel.conf

	eautoconf
}

src_configure() {
	append-flags -fno-strict-aliasing # some code breaks strict aliasing
	econf --docdir=/usr/share/doc/${PF} \
		--enable-localtime \
		--disable-start-stop-daemon \
		--without-sqlite2 \
		$(use_enable pam) \
		$(use_enable debug debug) \
		$(use_enable pcre) \
		$(use_enable doc docs) \
		$(use_enable ssl) \
		$(use_with mysql) \
		$(use_with sqlite sqlite3) \
		$(use_with postgres pgsql) \
		|| die "econf failed"
}

# phase disabled by RESTRICT
# src_test() {
# 	emake check || die "emake check failed"
# }

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	if use doc; then
		emake DESTDIR="${D}" install-docs || die "emake install-docs failed"
	fi
	dodoc README

	diropts -g kannel -m0750
	dodir /etc/kannel
	insinto /etc/kannel
	newins doc/examples/kannel.conf kannel.conf.sample

	local f
	for f in bearerbox smsbox wapbox; do
		newinitd "${FILESDIR}/kannel-$f.initd" kannel-$f
	done

	diropts -g kannel -m0770
	keepdir /var/log/kannel /var/run/kannel
}

pkg_postinst() {
	if use ssl; then
		elog "SSL certificate can be created by running"
		elog "   emerge --config =${CATEGORY}/${PF}"
	fi
}

pkg_config() {
	if use ssl; then
		if install_cert /etc/ssl/kannel; then
			chown kannel "${ROOT}"etc/ssl/kannel.{pem,key}
			einfo "For using this certificate, you have to add following line to your kannel.conf:"
			einfo '   ssl-client-certkey-file = "/etc/ssl/kannel.pem"'
			einfo '   ssl-server-cert-file = "/etc/ssl/kannel.crt"'
			einfo '   ssl-server-key-file = "/etc/ssl/kannel.key"'
		fi
	else
		eerror "This phase exists only for creating kannel SSL certificate"
		eerror "and ssl USE flag is disabled for this package!"
	fi
}
