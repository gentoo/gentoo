# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/sarg/sarg-2.3.9.ebuild,v 1.2 2014/10/28 09:03:43 jer Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="Squid Analysis Report Generator"
HOMEPAGE="http://sarg.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
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
	epatch \
		"${FILESDIR}"/${P}-configure.patch \
		"${FILESDIR}"/${P}-configure-bash.patch

	sed -i \
		-e 's:/usr/local/squid/var/logs/access.log:/var/log/squid/access.log:' \
		-e 's:/usr/local/\(squidGuard/squidGuard.conf\):/etc/\1:' \
		-e 's:/var/www/html/squid-reports:/var/www/localhost/htdocs/squid-reports:' \
		-e 's:/usr/local/sarg/exclude_codes:/etc/sarg/exclude_codes:' \
		sarg.conf || die

	sed -i \
		-e 's:"/var/www/html/squid-reports":"/var/www/localhost/htdocs/squid-reports":' \
		log.c || die #43132

	sed	-i \
		-e 's:/usr/local/sarg/passwd:/etc/sarg/passwd:' \
		htaccess || die

	sed -i \
		-e 's:/usr/local/\(sarg/sarg.conf\):/etc/\1:' \
		-e 's:/usr/local/squid/etc/passwd:/etc/squid/passwd:' \
		user_limit_block || die

	sed -i \
		-e 's:/usr/local/squid/etc/block.txt:/etc/squid/etc/block.txt:' \
		sarg-php/sarg-block-it.php || die

	sed -i \
		-e 's:/usr/local/\(sarg/sarg.conf\):/etc/\1:' \
		-e 's:/usr/local/\(squidGuard/squidGuard.conf\):/etc/\1:' \
		sarg.1 sarg-php/sarg-squidguard-block.php || die

	eautoreconf
}

src_configure() {
	econf \
		$(use_with gd) \
		$(use_with ldap) \
		$(use_with pcre) \
		--sysconfdir="${EPREFIX}/etc/sarg/"
}
