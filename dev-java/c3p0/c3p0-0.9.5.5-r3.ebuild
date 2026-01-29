# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Tests require an existing running SQL server and 'junit.jar.file' property
JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2

DESCRIPTION="JDBC drivers with JNDI-bindable DataSources"
HOMEPAGE="https://www.mchange.com/projects/c3p0/"
SRC_URI="https://downloads.sourceforge.net/project/c3p0/c3p0-src/c3p0-${PV}/${P}.src.tgz"
S="${WORKDIR}/${P}.src"

LICENSE="|| ( EPL-1.0 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

BDEPEND=">=dev-java/ant-1.10.15:0"
CP_DEPEND=">=dev-java/mchange-commons-0.2.20-r1:0"

DEPEND="
	>=dev-java/log4j-12-api-2.25.2:0
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
"

RDEPEND="
	!<app-forensics/sleuthkit-4.12.1-r3:0
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

PATCHES=( "${FILESDIR}/c3p0-0.9.5.5-source-target.patch" )

src_prepare() {
	java-pkg_clean
	default #780585
	java-pkg-2_src_prepare
	java-pkg_jar-from --build-only --into lib/ log4j-12-api
	java-pkg_jar-from --into lib/ mchange-commons

	# Test sources interfere with Javadoc generation on JDK 11
	# Remove since the tests will never be run
	rm -r src/java/com/mchange/v2/c3p0/test ||
		die "Failed to remove unused test sources"
}

src_compile() {
	eant jar $(usev doc javadoc) \
		-Dant.build.javac.source="$(java-pkg_get-source)" \
		-Dant.build.javac.target="$(java-pkg_get-target)"
}

src_install() {
	java-pkg_newjar "build/${P}.jar"
	einstalldocs

	use doc && java-pkg_dojavadoc build/apidocs
	use examples && java-pkg_doexamples src/java/com/mchange/v2/c3p0/example
	use source && java-pkg_dosrc src/java/com/mchange/v2
}
