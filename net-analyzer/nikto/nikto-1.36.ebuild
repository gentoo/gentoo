# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nikto/nikto-1.36.ebuild,v 1.7 2014/11/09 23:30:53 patrick Exp $

DESCRIPTION="Web Server vulnerability scanner"
HOMEPAGE="http://www.cirt.net/Nikto2"
SRC_URI="http://www.cirt.net/source/nikto/ARCHIVE/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc sparc x86"
RDEPEND="dev-lang/perl
		>=net-analyzer/nmap-3.00
		ssl? ( dev-libs/openssl )"
IUSE="ssl"

src_compile() {
	sed	-i -e 's:config.txt:nikto.conf:' \
		-i -e 's:\$CFG{configfile}="nikto.conf":\$CFG{configfile}="/etc/nikto/nikto.conf":' \
		 nikto.pl

	mv config.txt nikto.conf

	sed -i -e 's:^#NMAP:NMAP:' \
		-i -e 's:^PROXYHOST:#PROXYHOST:' \
		-i -e 's:^PROXYPORT:#PROXYPORT:' \
		-i -e 's:^PROXYUSER:#PROXYUSER:' \
		-i -e 's:^PROXYPASS:#PROXYPASS:' \
		-i -e 's:# PLUGINDIR=/usr/local/nikto/plugins:PLUGINDIR=/usr/share/nikto/plugins:' \
		 nikto.conf

		 cp "${S}/docs/nikto-${PV}.man" "${WORKDIR}/${PN}.1"
}

src_install() {
	insinto /etc/nikto
	doins nikto.conf

	dodir /usr/bin
	dobin nikto.pl
	dosym /usr/bin/nikto.pl /usr/bin/nikto

	dodir /usr/share/nikto/plugins
	insinto /usr/share/nikto/plugins
	doins plugins/*

	cd docs
	dodoc CHANGES.txt LICENSE.txt README_plugins.txt nikto_usage.txt
	dohtml nikto_usage.html
	doman "${WORKDIR}/${PN}.1"
}
