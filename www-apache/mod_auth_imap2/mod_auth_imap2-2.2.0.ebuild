# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit apache-module

MY_PN="${PN/imap2/imap}"
KEYWORDS="~amd64 ~x86"

DESCRIPTION="An Apache2 module to provide authentication via an IMAP Mail server"
HOMEPAGE="http://ben.brillat.net/projects/mod_auth_imap/"
SRC_URI="http://ben.brillat.net/files/projects/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

APXS2_ARGS="-c ${MY_PN}.c"

APACHE2_MOD_CONF="10_${MY_PN}"
APACHE2_MOD_DEFINE="AUTH_IMAP"
APACHE2_MOD_FILE=".libs/${MY_PN}.so"

DOCFILES="CHANGELOG README examples/*"

need_apache2
