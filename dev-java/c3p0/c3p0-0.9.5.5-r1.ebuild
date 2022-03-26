# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Tests require an existing running SQL server and 'junit.jar.file' property
JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="JDBC drivers with JNDI-bindable DataSources"
HOMEPAGE="https://www.mchange.com/projects/c3p0/"

SRC_URI="mirror://sourceforge/${PN}/${P}.src.tgz"
LICENSE="|| ( EPL-1.0 LGPL-2.1 )"
SLOT="0"
KEYWORDS="amd64 ppc64 ~x86 ~amd64-linux ~x86-linux"

CP_DEPEND="
	dev-java/log4j-12-api:2
	dev-java/mchange-commons:0
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

S="${WORKDIR}/${P}.src"

JAVA_ANT_REWRITE_CLASSPATH="yes"

src_prepare() {
	java-pkg_clean
	java-pkg-2_src_prepare
	java-pkg_jar-from --into lib/ log4j-12-api-2
	java-pkg_jar-from --into lib/ mchange-commons

	# Test sources interfere with Javadoc generation on JDK 11
	# Remove since the tests will never be run
	rm -r src/java/com/mchange/v2/c3p0/test ||
		die "Failed to remove unused test sources"
}

src_install() {
	java-pkg_newjar "build/${P}.jar"
	einstalldocs

	use doc && java-pkg_dojavadoc build/apidocs
	use examples && java-pkg_doexamples src/java/com/mchange/v2/c3p0/example
	use source && java-pkg_dosrc src/java/com/mchange/v2
}
