# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit java-pkg-2

DESCRIPTION="JSR 181 API classes"
HOMEPAGE="http://jax-ws.dev.java.net/"
DATE="20060817"
MY_P="JAXWS2.0.1m1_source_${DATE}.jar"
SRC_URI="https://jax-ws.dev.java.net/jax-ws-201-m1/${MY_P}"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${RDEPEND}"

S="${WORKDIR}/jaxws-si"

src_unpack() {
	printf '%s\n' "A" | $(java-config --java) -jar "${DISTDIR}/${A}" -console > /dev/null || die "unpack failed"
	unpack ./jaxws-src.zip || die "unzip failed"
}

src_compile() {
	:
}

src_install() {
	java-pkg_newjar lib/jsr181-api.jar
}
