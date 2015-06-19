# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/sarg/sarg-2.3.8.ebuild,v 1.5 2014/08/13 09:27:49 ago Exp $

EAPI=5

inherit autotools eutils

DESCRIPTION="Squid Analysis Report Generator"
HOMEPAGE="http://sarg.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"
SLOT="0"
IUSE="+gd ldap pcre"

DEPEND="
	gd? ( media-libs/gd[png,truetype] )
	ldap? ( net-nds/openldap )
	pcre? ( dev-libs/libpcre )
"
RDEPEND="${DEPEND}"

DOCS=( BETA-TESTERS CONTRIBUTORS DONATIONS README ChangeLog htaccess )

src_prepare() {
	epatch "${FILESDIR}"/${P}-long-long-int.patch

	sed -i configure.in -e '/LDFLAGS=/s:LDFLAGS:LIBS:g' || die

	sed \
		-e 's:/usr/local/squid/var/logs/access.log:/var/log/squid/access.log:' \
		-e 's:/usr/local/\(squidGuard/squidGuard.conf\):/etc/\1:' \
		-e 's:/var/www/html/squid-reports:/var/www/localhost/htdocs/squid-reports:' \
		-e 's:/usr/local/sarg/exclude_codes:/etc/sarg/exclude_codes:' \
		-i sarg.conf || die

	sed -e 's:"/var/www/html/squid-reports":"/var/www/localhost/htdocs/squid-reports":' \
			-i log.c || die #43132

	sed	-e 's:/usr/local/sarg/passwd:/etc/sarg/passwd:' \
		-i htaccess || die

	sed -e 's:/usr/local/\(sarg/sarg.conf\):/etc/\1:' \
		-e 's:/usr/local/squid/etc/passwd:/etc/squid/passwd:' \
		-i user_limit_block || die

	sed -e 's:/usr/local/squid/etc/block.txt:/etc/squid/etc/block.txt:' \
		-i sarg-php/sarg-block-it.php || die

	sed -e 's:/usr/local/\(sarg/sarg.conf\):/etc/\1:' \
		-e 's:/usr/local/\(squidGuard/squidGuard.conf\):/etc/\1:' \
			-i sarg.1 sarg-php/sarg-squidguard-block.php || die

	eautoconf
}

src_configure() {
	econf \
		$(use_with gd) \
		$(use_with ldap) \
		$(use_with pcre) \
		--sysconfdir="${EPREFIX}/etc/sarg/"
}
