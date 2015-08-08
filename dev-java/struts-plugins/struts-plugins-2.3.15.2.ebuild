# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

MY_PN="struts"
MY_P="${MY_PN}-${PV}-src"

DESCRIPTION="A powerful Model View Controller Framework for JSP/Servlets: Plugins"
SRC_URI="mirror://apache/struts/source/${MY_P}.zip
	http://dev.gentoo.org/~tomwij/files/dist/${MY_PN}-build.xml-${PV}.tar.xz
	http://dev.gentoo.org/~tomwij/files/dist/${MY_PN}-${PV}-build.xml-classpath.patch"
HOMEPAGE="http://struts.apache.org/index.html"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64"

COMMON_DEPS="dev-java/commons-beanutils:1.7
	dev-java/commons-lang:3.1
	dev-java/commons-io:1
	dev-java/freemarker:2.3
	dev-java/juel:0
	dev-java/ognl:3.0
	dev-java/osgi-core-api:0
	dev-java/struts-core:${SLOT}
	dev-java/struts-xwork:${SLOT}
	dev-java/velocity:0
	java-virtuals/servlet-api:3.0"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPS}"

DEPEND=">=virtual/jdk-1.5
	test? ( dev-java/ant-junit:0 )
	${COMMON_DEPS}"

S="${WORKDIR}/${MY_PN}-${PV}/src/plugins"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="struts-core-${SLOT},struts-xwork-${SLOT}"
EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH}"
EANT_BUILD_TARGET="package"
EANT_TEST_TARGET="test"

# javatemplates/maven-build.xml:149:
# Test org.apache.struts2.views.java.simple.AbstractCommonAttributesTest failed
# Cannot instantiate test case: testRenderTextFieldDynamicAttrs
RESTRICT="test"

src_unpack() {
	unpack ${MY_P}.zip
	cd "${WORKDIR}"/${MY_PN}-${PV}/src || die
	unpack ${MY_PN}-build.xml-${PV}.tar.xz
}

java_prepare() {
	find . -name '*.jar' -print -delete || die

	epatch "${DISTDIR}"/${MY_PN}-${PV}-build.xml-classpath.patch
	epatch "${FILESDIR}"/${MY_PN}-${PV}-build.xml-manifest.patch
	epatch "${FILESDIR}"/${MY_PN}-${PV}-build.xml-remove-codebehind.patch
	epatch "${FILESDIR}"/${MY_PN}-${PV}-build.xml-remove-portlet.patch

	# Remove tests that don't build due to test files that aren't installed.
	rm jfreechart/src/test/java/org/apache/struts2/dispatcher/ChartResultTest.java

	java-pkg_getjars commons-beanutils-1.7,commons-io-1,commons-lang-3.1,freemarker-2.3,juel,ognl-3.0,osgi-core-api,servlet-api-3.0,velocity
}

src_test() {
	EANT_TEST_EXTRA_ARGS="-Dgentoo.test.classpath=$(java-pkg_getjars ${EANT_TEST_GENTOO_CLASSPATH})"
	EANT_TEST_EXTRA_ARGS+=" -Djunit.present=true"

	java-pkg-2_src_test
}

src_install() {
	for plugin in $(find . -mindepth 1 -maxdepth 1 -type d | sed 's:./::g' | tr '\n' ' ') ; do
		[[ ! -d ${plugin}/target ]] && continue

		einfo "Installing plugin '${plugin}' ..."
		java-pkg_newjar ${plugin}/target/${MY_PN}2-${plugin}-plugin-${PV}.jar ${plugin}.jar

		if use doc ; then
			java-pkg_dojavadoc ${plugin}/target/site/apidocs
			mkdir "${D}"/usr/share/doc/${P}/${plugin} || die
			mv "${D}"/usr/share/doc/${P}/{html,${plugin}/html} || die
		fi

		use source && java-pkg_dosrc ${plugin}/src/main/java/org
	done

	if use doc ; then
		rm "${D}"/usr/share/${PN}-${SLOT}/api || die
	fi
}

pkg_postinst() {
	elog "The 'codebehind' and 'portlet' plugins are not in this release because they don't build yet."
}
