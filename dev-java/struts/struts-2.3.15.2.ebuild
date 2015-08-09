# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source test"
WANT_ANT_TASKS="ant-trax"

inherit java-pkg-2 java-ant-2

MY_P="${P}-src"

DESCRIPTION="A powerful Model View Controller Framework for JSP/Servlets"
SRC_URI="mirror://apache/struts/source/${MY_P}.zip
	http://dev.gentoo.org/~tomwij/files/dist/${PN}-build.xml-${PV}.tar.xz"
HOMEPAGE="http://struts.apache.org/index.html"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64"

COMMON_DEPS="
	dev-java/felix-shell:0
	dev-java/osgi-core-api:0
	dev-java/struts-core:${SLOT}
	dev-java/struts-plugins:${SLOT}
	dev-java/struts-xwork:${SLOT}
	java-virtuals/servlet-api:2.3"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPS}"

DEPEND=">=virtual/jdk-1.5
	test? ( dev-java/ant-junit:0 )
	${COMMON_DEPS}"

S="${WORKDIR}/${P}/src"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="struts-core-${SLOT},struts-plugins-${SLOT},struts-xwork-${SLOT}"
EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH}"
EANT_BUILD_TARGET="package"
EANT_TEST_TARGET="test"

# TODO: Incompatible with newer junit; we either need to patch it or slot junit.
RESTRICT="test"

src_unpack() {
	unpack ${MY_P}.zip
	cd "${S}" || die
	unpack ${PN}-build.xml-${PV}.tar.xz
}

java_prepare() {
	find . -name '*.jar' -print -delete || die

	epatch "${FILESDIR}"/${P}-build.xml-remove-core-and-plugins.patch
	epatch "${FILESDIR}"/${P}-build.xml-classpath.patch
	epatch "${FILESDIR}"/${P}-build.xml-manifest.patch
	epatch "${FILESDIR}"/${P}-build.xml-apps-package.patch
	epatch "${FILESDIR}"/${P}-build.xml-remove-apps-portlet.patch

	java-pkg_getjars felix-shell,osgi-core-api,servlet-api-2.3
}

src_install() {
	insinto /usr/share/${PN}-${SLOT}/

	# Misses apps/portlet.
	for dir in apps/{blank,mailreader,rest-showcase,showcase} bundles/{admin,demo} ; do
		if [[ ${dir} == "apps/"* ]] ; then
			doins ${dir}/target/${PN}2-${dir/apps\//}.war
		else
			java-pkg_newjar ${dir}/target/${PN}2-osgi-*-bundle-${PV}.jar ${dir/bundles\//}.jar
		fi

		if use doc ; then
			java-pkg_dojavadoc ${dir}/target/site/apidocs
			mkdir "${D}"/usr/share/doc/${P}/${dir/*\//} || die
			mv "${D}"/usr/share/doc/${P}/{html,${dir/*\//}/html} || die
		fi

		if [[ ${dir} == *"mailreader"* ]] ; then
			use source && java-pkg_dosrc ${dir}/src/main/java/mailreader2
		else
			use source && java-pkg_dosrc ${dir}/src/main/java/org
		fi
	done

	if use doc ; then
		rm "${D}"/usr/share/${PN}-${SLOT}/api || die
	fi
}

src_test() {
	EANT_TEST_EXTRA_ARGS="-Dgentoo.test.classpath=$(java-pkg_getjars ${EANT_TEST_GENTOO_CLASSPATH})"
	EANT_TEST_EXTRA_ARGS+=" -Djunit.present=true"

	java-pkg-2_src_test
}

pkg_postinst() {
	elog "The application 'portlet' is not in this release because it doesn't build."
}
