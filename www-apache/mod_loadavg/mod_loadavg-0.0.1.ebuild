# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit apache-module eutils

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Apache module executing CGI-Requests depending on the load of the server"
HOMEPAGE="http://defunced.de/"
SRC_URI="mirror://gentoo/${P}.c"
LICENSE="Apache-1.1"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

APACHE2_MOD_CONF="10_${PN}"
APACHE2_MOD_DEFINE="LOADAVG"

need_apache2_2

src_unpack() {
	mkdir -p "${S}" || die "mkdir S failed"
	cp -f "${DISTDIR}/${P}.c" "${S}/${PN}.c" || die "source copy failed"
}
