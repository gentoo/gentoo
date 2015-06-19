# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_extract_forwarded/mod_extract_forwarded-2.0.2.ebuild,v 1.5 2014/08/10 20:15:28 slyfox Exp $

EAPI="3"

inherit apache-module

DESCRIPTION="Apache module that rewrites X-Forwarded-For to REMOTE_ADDR for reverse proxy configurations"
HOMEPAGE="http://www.openinfo.co.uk/apache/index.html"
SRC_URI="http://www.openinfo.co.uk/apache/extract_forwarded-${PV}.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="mod_proxy"

DEPEND=""
RDEPEND="mod_proxy? ( www-servers/apache[apache2_modules_proxy_connect] )"

S="${WORKDIR}/extract_forwarded"

APACHE2_MOD_CONF="98_${PN}"
APACHE2_MOD_DEFINE="EXTRACT_FORWARDED"

need_apache2_2

src_prepare() {
	if ! use mod_proxy; then
		sed -i -e 's:#define USING_proxy_http_module .*::' mod_extract_forwarded.c || die
	fi
}
