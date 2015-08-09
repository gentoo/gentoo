# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="JAXWS 2.0 API Final Release"
HOMEPAGE="https://jax-ws.dev.java.net/"
SRC_URI="https://jax-ws.dev.java.net/files/documents/4202/34734/jaxws-api-fcs-src.zip"

LICENSE="CDDL"
SLOT="2"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"

IUSE=""

COMMON_DEP="dev-java/jsr67
	=dev-java/jaxb-2*"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEP}"

S="${WORKDIR}"

src_unpack() {

	unpack ${A}

	mkdir lib
	cd lib
	java-pkg_jar-from jsr67
	java-pkg_jar-from jaxb-2

	cp "${FILESDIR}/build.xml-${PV}" "${S}/build.xml" || die

}

src_install() {

	java-pkg_dojar "${PN}.jar"

	use source && java-pkg_dosrc .

}
