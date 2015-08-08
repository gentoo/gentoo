# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Reference implementation of the Java API for XML Web Services"
HOMEPAGE="http://jax-ws.dev.java.net/"
DATE="20060817"
MY_P="JAXWS${PV}m1_source_${DATE}.jar"
SRC_URI="https://jax-ws.dev.java.net/jax-ws-201-m1/${MY_P}"

LICENSE="CDDL"
SLOT="2"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

COMMON_DEP="dev-java/istack-commons-runtime:0
	dev-java/jax-ws-api:2
	dev-java/jaxb:2
	dev-java/jsr173:0
	>=dev-java/jsr181-1.0
	dev-java/jsr250:0
	dev-java/sun-httpserver-bin:2
	dev-java/jsr67:0
	dev-java/saaj:0
	dev-java/sjsxp:0
	dev-java/stax-ex:0
	dev-java/sun-jaf:0
	dev-java/txw2-runtime:0
	dev-java/xmlstreambuffer:0
	dev-java/xml-commons-resolver:0"

# abstract interface problems with 1.5
# https://bugs.gentoo.org/show_bug.cgi?id=207633
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEP}"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"

S="${WORKDIR}/jaxws-si"

src_unpack() {
	echo "A" | java -jar "${DISTDIR}/${A}" -console > /dev/null || die "unpack failed"

	unpack ./jaxws-src.zip || die "unzip failed"
}

java_prepare() {
	cd "${S}/lib"
	rm -v *.jar || die

	java-pkg_jarfrom istack-commons-runtime
	java-pkg_jarfrom jax-ws-api-2
	java-pkg_jarfrom jaxb-2
	java-pkg_jarfrom jsr173
	java-pkg_jarfrom jsr181
	java-pkg_jarfrom jsr250
	java-pkg_jarfrom jsr67
	java-pkg_jarfrom saaj
	java-pkg_jarfrom sjsxp
	java-pkg_jarfrom sun-httpserver-bin-2
	java-pkg_jarfrom stax-ex
	java-pkg_jarfrom sun-jaf
	java-pkg_jarfrom txw2-runtime
	java-pkg_jarfrom xml-commons-resolver
	java-pkg_jarfrom xmlstreambuffer

	cp \
		"${S}"/src/rt/build/gen-src/com/sun/xml/ws/resources/*.java \
		"${S}"/src/rt/src/com/sun/xml/ws/resources/ || die "cp failed"

	find "${S}/src/" -name '*.java' -exec \
		sed -i -e \
			's,com.sun.org.apache.xml.internal.resolver,org.apache.xml.resolver,g' \
			{} \;

	cd "${S}"
	epatch "${FILESDIR}/${P}-gentoo.patch"
	java-ant_rewrite-bootclasspath auto build.xml "$(java-pkg_getjars jax-ws-api-2)"
}

EANT_BUILD_TARGET="build"

src_install() {
	java-pkg_dojar jax-ws.jar

	use source && java-pkg_dosrc src/rt/src/*
}
