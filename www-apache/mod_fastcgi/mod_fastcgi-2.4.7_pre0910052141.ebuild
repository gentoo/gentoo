# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_fastcgi/mod_fastcgi-2.4.7_pre0910052141.ebuild,v 1.6 2014/08/10 20:15:34 slyfox Exp $

inherit apache-module

MY_P="${PN}-SNAP-${PV/2.4.7_pre/}"

DESCRIPTION="FastCGI is a open extension to CGI without the limitations of server specific APIs"
HOMEPAGE="http://fastcgi.com/"
SRC_URI="http://www.fastcgi.com/dist/${MY_P}.tar.gz"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="mod_fastcgi"
IUSE=""

APXS2_ARGS="-c mod_fastcgi.c fcgi*.c"
APACHE2_MOD_CONF="20_${PN}"
APACHE2_MOD_DEFINE="FASTCGI"

DOCFILES="CHANGES README docs/LICENSE.TERMS docs/mod_fastcgi.html"

S="${WORKDIR}/${MY_P}"

need_apache2_2
