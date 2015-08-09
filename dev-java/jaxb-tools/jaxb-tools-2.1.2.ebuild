# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="1"
JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Reference implementation of the JAXB specification"
HOMEPAGE="http://jaxb.dev.java.net/"
SRC_URI="https://jaxb.dev.java.net/${PV}/JAXB2_src_20070125.jar"

LICENSE="CDDL"
SLOT="2"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

COMMON_DEP="dev-java/codemodel:2
	dev-java/iso-relax:0
	dev-java/istack-commons-runtime:0
	dev-java/istack-commons-tools:0
	dev-java/jaxb:2
	dev-java/jsr173:0
	dev-java/msv:0
	dev-java/relaxng-datatype:0
	dev-java/rngom:0
	dev-java/sun-dtdparser:0
	dev-java/sun-jaf:0
	dev-java/txw2-runtime:0
	dev-java/xml-commons-resolver:0
	dev-java/xsdlib:0
	dev-java/xsom:0"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"

S="${WORKDIR}/jaxb-ri-20070125"

src_unpack() {

	cd "${WORKDIR}"
	echo "A" | java -jar "${DISTDIR}/${A}" -console > /dev/null || die "unpack failed"

	cd "${S}/lib"
	rm -v *.jar || die

	java-pkg_jarfrom --build-only ant-core
	java-pkg_jarfrom codemodel-2
	java-pkg_jarfrom iso-relax
	java-pkg_jarfrom istack-commons-runtime
	java-pkg_jarfrom istack-commons-tools
	java-pkg_jarfrom jaxb-2
	java-pkg_jarfrom jsr173
	java-pkg_jarfrom msv
	java-pkg_jarfrom relaxng-datatype
	java-pkg_jarfrom rngom
	java-pkg_jarfrom sun-dtdparser
	java-pkg_jarfrom sun-jaf
	java-pkg_jarfrom txw2-runtime
	java-pkg_jarfrom xml-commons-resolver
	java-pkg_jarfrom xsdlib
	java-pkg_jarfrom xsom
	ln -s $(java-config --tools) || die

	cd "${S}/src/com/sun/"
	rm -rf codemodel # in dev-java/codemodel
	rm -rf xml # in dev-java/jaxb

	cd "${S}"
	# Their build.xml does not do everything we want
	cp -v "${FILESDIR}/build.xml-${PV}" build.xml || die "cp failed"

	find src -name '*.java' -exec \
		sed -i \
			-e 's,com.sun.org.apache.xml.internal.resolver,org.apache.xml.resolver,g' \
			{} \;

}

src_install() {
	java-pkg_dojar jaxb-tools.jar
	java-pkg_dolauncher "xjc-${SLOT}" \
		--main com.sun.tools.xjc.Driver

	use source && java-pkg_dosrc src/*

}
