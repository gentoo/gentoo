# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit multilib

DESCRIPTION="A framework for analysing applications that communicate using the HTTP and HTTPS protocols"
HOMEPAGE="https://www.owasp.org/index.php/Webscarab"
SRC_URI="mirror://sourceforge/owasp/${PN}-selfcontained-${PV}-1631.jar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND=">=virtual/jre-1.5"

src_unpack() {
	: # Nothing to unpack
}

src_install() {
	newbin "${FILESDIR}/${PN}.sh" "${PN}" || die "dobin failed"
	insinto /usr/$(get_libdir)
	newins "${DISTDIR}/${A}" "${PN}.jar" || die "failed to install jar archive"
}
