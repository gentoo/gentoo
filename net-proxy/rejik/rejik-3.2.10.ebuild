# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils toolchain-funcs

DESCRIPTION="A squid redirector used for blocking unwanted content"
HOMEPAGE="http://rejik.ru/"
SRC_URI="http://rejik.ru/download/redirector-${PV}.tgz
	banlists? ( http://rejik.ru/download/banlists-2.x.x.tgz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="banlists"

DEPEND="dev-libs/libpcre"
RDEPEND="${DEPEND}
	dev-perl/Text-Iconv
	dev-perl/XML-Parser
	net-proxy/squid"

S=${WORKDIR}/redirector-${PV}

src_prepare() {
	sed -i -e "s:INSTALL_PATH=/usr/local/rejik3:INSTALL_PATH=${D}/opt/rejik:g" Makefile
	sed -i -e "s:/usr/local/rejik3:/opt/rejik:g" vars.h
	sed -i -e "s:SQUID_USER=nobody:SQUID_USER=squid:g" Makefile
	sed -i -e "s:SQUID_GROUP=nogroup:SQUID_GROUP=squid:g" Makefile
	# Respect CFLAGS
	sed -i -e "s:CC=gcc -Wall:CC=$(tc-getCC) $CFLAGS:" Makefile
	# Respect LDFLAGS
	sed -i -e "s:LIBS=-L/lib \`pcre-config --libs\`:LIBS=-L/lib \`pcre-config --libs\` $LDFLAGS:" Makefile
	#
	sed -i -e "s:error_log /usr/local/rejik3:error_log /var/log/rejik:g" redirector.conf.dist
	sed -i -e "s:change_log /usr/local/rejik3:change_log /var/log/rejik:g" redirector.conf.dist
	sed -i -e "s:/usr/local/rejik3:/opt/rejik:g" redirector.conf.dist
}

src_install() {
	dodir /opt/rejik
	exeinto /opt/rejik
	insinto /opt/rejik

	doexe make-cache
	doexe redirector
	doins redirector.conf.dist

	dodir /opt/rejik/tools
	insinto /opt/rejik/tools
	exeinto /opt/rejik/tools

	fperms +x tools/kill-cache
	fperms +x tools/benchmark

	doexe tools/kill-cache
	doexe tools/benchmark
	doins tools/IN.gz

	fowners -R squid:squid /opt/rejik
	fperms 750 /opt/rejik

	keepdir /var/log/rejik
	fowners -R squid:squid /var/log/rejik

	if use banlists; then
		insinto /opt/rejik
		doins -r "${WORKDIR}/banlists"
	fi
}

pkg_postinst() {
	einfo ""
	einfo "Copy /opt/rejik/redirector.conf.dist to /opt/rejik/redirector.conf and add line"
	einfo "for squid 3.*"
	einfo "url_rewrite_program /opt/rejik/redirector /opt/rejik/redirector.conf "
	einfo "for squid 2.*"
	einfo "redirect_program /opt/rejik/redirector /opt/rejik/redirector.conf"
	einfo "to /etc/squid/squid.conf"
	einfo ""
	einfo "Dont forget to edit /opt/rejik/redirector.conf"
	einfo "Be sure redirector.conf has right permissions"
}
