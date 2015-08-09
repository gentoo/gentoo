# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source test"
WANT_ANT_TASKS="ant-nodeps"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Woodstox is a high-performance validating namespace-aware XML-processor"
HOMEPAGE="http://woodstox.codehaus.org/"
SRC_URI="http://woodstox.codehaus.org/${PV}/${PN}-src-${PV}.zip"

LICENSE="Apache-2.0"
SLOT="3.2"
KEYWORDS="amd64 ppc ppc64 x86"

COMMON_DEP="
	dev-java/emma:0
	dev-java/sax:0
	java-virtuals/jaxp-virtual
	dev-java/stax:0
	dev-java/msv:0
	dev-java/xsdlib:0
	dev-java/relaxng-datatype:0
	dev-java/junit:0"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEP}"

EANT_BUILD_TARGET="jars"
EANT_DOC_TARGET="javadoc"

# Don't need to make a folder
S="${WORKDIR}"

JAVA_ANT_REWRITE_CLASSPATH="true"

java_prepare() {
	rm -v lib/msv/*.jar || die
	rm -v lib/*.jar || die

	# Get rid of a missing include.
	epatch "${FILESDIR}"/${P}-build.xml.patch
}

EANT_GENTOO_CLASSPATH="emma,sax,jaxp-virtual,msv,xsdlib,relaxng-datatype,junit"

src_test(){
	ANT_TASKS="ant-junit ant-nodeps ant-trax" eant test || die "Tests failed"
}

src_install() {
	java-pkg_newjar build/"${PN}"-api-"${PV}".jar "${PN}"-api.jar
	java-pkg_newjar build/"${PN}"-asl-"${PV}".jar "${PN}".jar
	use doc && java-pkg_dojavadoc build/javadoc
	use source && java-pkg_dosrc src
}
