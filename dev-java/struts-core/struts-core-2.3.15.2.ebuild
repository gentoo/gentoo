# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2

MY_PN="struts"
MY_P="${MY_PN}-${PV}-src"

DESCRIPTION="A powerful Model View Controller Framework for JSP/Servlets: Core"
SRC_URI="mirror://apache/struts/source/${MY_P}.zip
	http://dev.gentoo.org/~tomwij/files/dist/${MY_PN}-build.xml-${PV}.tar.xz"
HOMEPAGE="http://struts.apache.org/index.html"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64"

COMMON_DEPS="dev-java/commons-fileupload:0
	dev-java/commons-lang:3.1
	dev-java/freemarker:2.3
	dev-java/ognl:3.0
	dev-java/struts-xwork:2
	dev-java/velocity:0
	java-virtuals/servlet-api:3.0"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPS}"

DEPEND=">=virtual/jdk-1.5
	test? ( dev-java/ant-junit:0 )
	${COMMON_DEPS}"

S="${WORKDIR}/${MY_PN}-${PV}/src/core"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="struts-xwork-2"

src_unpack() {
	unpack ${MY_P}.zip
	cd "${WORKDIR}"/${MY_PN}-${PV}/src || die
	unpack ${MY_PN}-build.xml-${PV}.tar.xz

	java-pkg_getjars commons-fileupload,commons-lang-3.1,freemarker-2.3,ognl-3.0,velocity,servlet-api-3.0
}

java_prepare() {
	find . -name '*.jar' -print -delete || die

	epatch "${FILESDIR}"/${MY_PN}-${PV}-build.xml-classpath.patch
	epatch "${FILESDIR}"/${MY_PN}-${PV}-build.xml-manifest.patch
}

src_test() {
	EANT_TEST_EXTRA_ARGS="-Djunit.present=true" java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar target/${MY_PN}2-core-${PV}.jar

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/com
}
