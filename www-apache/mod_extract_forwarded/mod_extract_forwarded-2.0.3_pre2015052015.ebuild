# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit apache-module

DESCRIPTION="Apache module that rewrites X-Forwarded-For to REMOTE_ADDR for reverse proxy configurations"
HOMEPAGE="http://www.openinfo.co.uk/apache/index.html"
#SRC_URI="http://www.openinfo.co.uk/apache/extract_forwarded-${PV}.tar.gz"
SRC_URI="https://dev.gentoo.org/~pacho/maintainer-needed/${P}.tar.xz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="mod_proxy"

DEPEND=""
RDEPEND="mod_proxy? ( www-servers/apache[apache2_modules_proxy_connect] )"

APACHE2_MOD_CONF="98_${PN}"
APACHE2_MOD_DEFINE="EXTRACT_FORWARDED"

need_apache2_4

src_prepare() {
	if ! use mod_proxy; then
		sed -i -e 's:#define USING_proxy_http_module .*::' mod_extract_forwarded.c || die
	fi
}
