# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jsr250/jsr250-1.0.ebuild,v 1.10 2015/06/12 13:24:10 monsieurp Exp $

inherit java-pkg-2 java-ant-2

DESCRIPTION="JSR 250 Common Annotations"
HOMEPAGE="http://jax-ws.dev.java.net/"
DATE="20060817"
MY_P="JAXWS2.0.1m1_source_${DATE}.jar"
SRC_URI="https://jax-ws.dev.java.net/jax-ws-201-m1/${MY_P}"

LICENSE="CDDL"
SLOT="0"
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

	java-pkg_newjar lib/jsr250-api.jar

}
