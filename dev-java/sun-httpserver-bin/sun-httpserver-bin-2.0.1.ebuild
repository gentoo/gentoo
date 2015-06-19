# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/sun-httpserver-bin/sun-httpserver-bin-2.0.1.ebuild,v 1.5 2008/03/28 17:59:05 nixnut Exp $

inherit java-pkg-2

DESCRIPTION="Sun sun.net.httpserver classes"
HOMEPAGE="http://jax-ws.dev.java.net/"
DATE="20060817"
MY_P="JAXWS${PV}m1_source_${DATE}.jar"
SRC_URI="https://jax-ws.dev.java.net/jax-ws-201-m1/${MY_P}"

LICENSE="CDDL"
SLOT="2"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND="app-arch/unzip
	${RDEPEND}"

S="${WORKDIR}/jaxws-si"

src_unpack() {

	echo "A" | java -jar "${DISTDIR}/${A}" -console > /dev/null || die "unpack failed"

	unpack ./jaxws-src.zip || die "unzip failed"

}

src_compile() {
	:
}

src_install() {

	java-pkg_dojar lib/http.jar

}
