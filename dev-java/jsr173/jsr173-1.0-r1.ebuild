# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="The Streaming API for XML (StAX) is a Java API for parsing and writing XML easily and efficiently"
HOMEPAGE="http://dev2dev.bea.com/xml/stax.html"
SRC_URI="http://ftpna2.bea.com/pub/downloads/${PN}.jar"

LICENSE="bea.ri.jsr173"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=">=virtual/jre-1.3
	dev-java/jaxme"
DEPEND=">=virtual/jdk-1.3
	${RDEPEND}"

S=${WORKDIR}

src_unpack() {
	cd "${S}"
	jar xvf ${DISTDIR}/${A} || die "failed to unpack"

	cp "${FILESDIR}/build-${PVR}.xml" build.xml

	jar xvf ${P//-/_}_src.jar || die "failed to unpack"
	rm -v *.jar || die
	cd lib
	rm -v *.jar || die
	java-pkg_jarfrom jaxme
}

src_compile() {
	local antflags="-Dproject.name=${PN} jar"
	eant ${antflags} $(use_doc) || die "Compilation failed"
}

src_install() {
	java-pkg_dojar dist/${PN}.jar

	use doc && java-pkg_dojavadoc dist/doc/api
	use source && java-pkg_dosrc src/*
}
