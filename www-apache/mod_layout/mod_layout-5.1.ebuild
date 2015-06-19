# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_layout/mod_layout-5.1.ebuild,v 1.5 2014/08/10 20:16:10 slyfox Exp $

inherit apache-module

DESCRIPTION="An Apache2 module for adding custom headers and/or footers"
HOMEPAGE="http://tangent.org/index.pl?node_id=362"
SRC_URI="http://download.tangent.org/${P}.tar.gz"

LICENSE="BSD"
SLOT="2"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=""
RDEPEND=""

APXS2_ARGS="-c ${PN}.c utility.c layout.c"

APACHE2_MOD_CONF="15_mod_layout"
APACHE2_MOD_DEFINE="LAYOUT"

DOCFILES="README"

need_apache2_2
