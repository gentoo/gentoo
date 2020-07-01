# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="JBoss logging framework"
HOMEPAGE="https://www.jboss.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.GA.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

COMMON_DEPEND="dev-java/jboss-logmanager:0
	>=dev-java/slf4j-api-1.7.7
	dev-java/log4j:0"

RDEPEND=">=virtual/jre-1.6
		${COMMON_DEPEND}"

DEPEND=">=virtual/jdk-1.6
		${COMMON_DEPEND}"

S="${WORKDIR}/${P}.GA/"

EANT_GENTOO_CLASSPATH="jboss-logmanager,slf4j-api,log4j"
JAVA_ANT_REWRITE_CLASSPATH="true"

java_prepare() {
	cp "${FILESDIR}"/${P}-build.xml build.xml || die

	# https://github.com/qos-ch/slf4j/blob/master/slf4j-api/src/main/java/org/slf4j/MDC.java#L226
	# MDC returns a Map<String, String>
	# https://github.com/jboss-logging/jboss-logging/blob/master/src/main/java/org/jboss/logging/Slf4jLoggerProvider.java#L57
	# Yet, for some reason, the JBoss folks have decided that it should return a Map<String, Object> :|
	# This patch mends this mistake.
	epatch "${FILESDIR}"/"${P}"-MDC.patch
}

src_install() {
	java-pkg_newjar target/${PN}-3.1.4.GA.jar

	if use doc; then
		java-pkg_dojavadoc target/site/apidocs
	fi
	use source && java-pkg_dosrc src/main/java/org
}
