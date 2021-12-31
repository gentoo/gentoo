# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="commons-logging:commons-logging:1.2"

inherit java-pkg-2 java-ant-2 java-osgi

DESCRIPTION="An ultra-thin bridge between different Java logging libraries"
HOMEPAGE="https://commons.apache.org/logging/"
SRC_URI="mirror://apache/commons/logging/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="avalon-framework avalon-logkit log4j servletapi test"
REQUIRED_USE="doc? ( avalon-framework avalon-logkit log4j servletapi )"
RESTRICT="!test? ( test ) !servletapi? ( test )"

CDEPEND="
	avalon-logkit? ( dev-java/avalon-logkit:2.0 )
	avalon-framework? ( dev-java/avalon-framework:4.2 )
	log4j? ( dev-java/log4j-12-api:2 )
	servletapi? ( dev-java/tomcat-servlet-api:4.0 )"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.8:*"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.8:*
	test? ( dev-java/ant-junit:0 )"

S="${WORKDIR}/${P}-src"

EANT_BUILD_TARGET="compile"
JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_CLASSPATH_TAGS="javac javadoc"
JAVA_ANT_IGNORE_SYSTEM_CLASSES="yes"

DOCS=( RELEASE-NOTES.txt PROPOSAL.html )

src_prepare() {
	default

	eapply "${FILESDIR}/${P}-gentoo.patch"
	# patch to make the build.xml respect no servletapi
	eapply "${FILESDIR}/${P}-servletapi.patch"

	# bug #208098
	echo "jdk.1.4.present=true" > build.properties || die

	if use avalon-framework; then
		echo "avalon-framework.jar=$(java-pkg_getjars avalon-framework-4.2)" >> build.properties || die
		EANT_GENTOO_CLASSPATH+=" avalon-framework-4.2"
	fi
	if use avalon-logkit; then
		echo "logkit.jar=$(java-pkg_getjars avalon-logkit-2.0)" >> build.properties || die
		EANT_GENTOO_CLASSPATH+=" avalon-logkit-2.0"
	fi
	if use log4j; then
		echo "log4j12.jar=$(java-pkg_getjars log4j-12-api-2,log4j-core-2)" >> build.properties || die
		EANT_GENTOO_CLASSPATH+=" log4j-12-api-2 log4j-core-2"
	fi

	if use servletapi; then
		echo "servletapi.jar=$(java-pkg_getjar tomcat-servlet-api-4.0 servlet-api.jar)" >> build.properties || die
		EANT_GENTOO_CLASSPATH+=" tomcat-servlet-api-4.0"
	fi
}

src_install() {
	local pkg=org.apache.commons.logging
	java-osgi_newjar "target/${P}.jar" "${pkg}" "Apache Commons Logging" "${pkg};version=\"${PV}\", ${pkg}.impl;version=\"${PV}\""
	java-pkg_newjar target/${PN}-api-${PV}.jar ${PN}-api.jar
	java-pkg_newjar target/${PN}-adapters-${PV}.jar ${PN}-adapters.jar

	einstalldocs
	use doc && java-pkg_dojavadoc target/docs/
	use source && java-pkg_dosrc src/main/java/org
}

src_test() {
	java-pkg-2_src_test
}
