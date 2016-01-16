# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="1"
JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Reference implementation of the JAXB specification"
HOMEPAGE="http://jaxb.dev.java.net/"
DATE="20070125"
MY_P="JAXB2_src_${DATE}"
SRC_URI="https://jaxb.dev.java.net/${PV}/${MY_P}.jar"

LICENSE="CDDL"
SLOT="2"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE=""

COMMON_DEP="
	dev-java/istack-commons-runtime:0
	dev-java/jsr173:0
	java-virtuals/jaf
	dev-java/txw2-runtime:0"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"

S="${WORKDIR}/jaxb-ri-${DATE}"

src_unpack() {
	echo "A" | java -jar "${DISTDIR}/${A}" -console > /dev/null || die "unpack failed"

	# Source is missing Messages.properties, copy it from binary version:
	cd "${T}"
	unzip -qq "${S}/lib/jaxb-api.jar"
	for mp in $(find javax -name '*.properties'); do
		mv "${mp}" "${S}/src/${mp}" || die
	done

	cd "${S}/lib"
	rm -v *.jar || die
	java-pkg_jarfrom --build-only ant-core
	java-pkg_jarfrom istack-commons-runtime
	java-pkg_jarfrom jsr173
	java-pkg_jarfrom jaf
	java-pkg_jarfrom txw2-runtime
	ln -s $(java-config --tools) || die

	cd "${S}/src/com/sun/"
	rm -rf codemodel # in dev-java/codemodel
	rm -rf tools # in dev-java/jaxb-tools

	cp -v "${FILESDIR}/build.xml-${PV}" "${S}/build.xml" || die "cp failed"

}

src_install() {
	java-pkg_dojar jaxb-api.jar
	java-pkg_dojar jaxb-impl.jar

	use source && java-pkg_dosrc src/*

}
