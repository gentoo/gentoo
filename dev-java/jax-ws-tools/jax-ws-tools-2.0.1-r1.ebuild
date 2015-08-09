# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=1
JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Reference implementation of the Java API for XML Web Services"
HOMEPAGE="http://jax-ws.dev.java.net/"
DATE="20060817"
MY_P="JAXWS${PV}m1_source_${DATE}.jar"
SRC_URI="https://jax-ws.dev.java.net/jax-ws-201-m1/${MY_P}"

LICENSE="CDDL"
SLOT="2"
KEYWORDS="amd64 ppc x86"
IUSE=""

COMMON_DEP="dev-java/istack-commons-runtime:0
	dev-java/istack-commons-tools:0
	dev-java/jaxb:2
	dev-java/jaxb-tools:2
	dev-java/txw2-runtime:0
	dev-java/jsr173:0
	>=dev-java/jsr181-1.0:0
	dev-java/jax-ws-api:2
	dev-java/jax-ws:2
	dev-java/codemodel:2
	dev-java/apt-mirror:0"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"

S="${WORKDIR}/jaxws-si"

src_unpack() {
	echo "A" | java -jar "${DISTDIR}/${A}" -console > /dev/null || die "unpack failed"

	unpack ./jaxws-src.zip || die "unzip failed"

	cd "${S}/lib"
	rm -v *.jar || die

	java-pkg_jarfrom istack-commons-runtime
	java-pkg_jarfrom istack-commons-tools
	java-pkg_jarfrom jaxb-2
	java-pkg_jarfrom jaxb-tools-2
	java-pkg_jarfrom txw2-runtime
	java-pkg_jarfrom jsr173
	java-pkg_jarfrom jsr181
	java-pkg_jarfrom jax-ws-api-2
	java-pkg_jarfrom jax-ws-2
	java-pkg_jarfrom codemodel-2
	java-pkg_jarfrom apt-mirror
	java-pkg_jarfrom --build-only ant-core
	ln -s $(java-config --tools) || die

	cp \
		"${S}"/src/tools/wscompile/build/gen-src/com/sun/tools/ws/resources/*.java \
		"${S}"/src/tools/wscompile/src/com/sun/tools/ws/resources/ || die "cp failed"

	find "${S}/src/" -name '*.java' -exec \
		sed -i -e \
			's,com.sun.org.apache.xml.internal.resolver,org.apache.xml.resolver,g' \
			{} \;

	cd "${S}"
	epatch "${FILESDIR}/${P}-gentoo.patch"
	epatch "${FILESDIR}/${P}-remove-unused-saaj-import.patch"

}

EANT_BUILD_TARGET="build"

src_install() {

	java-pkg_dojar jax-ws-tools.jar

	use source && java-pkg_dosrc src/tools/wscompile/src/*

}
