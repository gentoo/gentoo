# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_PROVIDES=(
	"org.opentest4j.reporting:open-test-reporting-schema:${PV}-M1"
	"org.opentest4j.reporting:open-test-reporting-events:${PV}-M1"
)

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Language-agnostic test reporting format and tooling"
HOMEPAGE="https://github.com/ota4j-team/open-test-reporting"
MY_PV="${PV/_pre/-M}"
SRC_URI="https://github.com/ota4j-team/open-test-reporting/archive/r${MY_PV}.tar.gz -> open-test-reporting-${MY_PV}.tar.gz"
S="${WORKDIR}/open-test-reporting-r${MY_PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

DEPEND="
	dev-java/apiguardian-api:0
	>=virtual/jdk-1.8:*
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_CLASSPATH_EXTRA="apiguardian-api"
JAVADOC_CLASSPATH="${JAVA_CLASSPATH_EXTRA}"
JAVADOC_SRC_DIRS=(
	"schema/src/main/java"
	"events/src/main/java"
)

src_compile() {
	einfo "open-test-reporting-schema.jar"
	JAVA_AUTOMATIC_MODULE_NAME="org.opentest4j.reporting.schema"
	JAVA_JAR_FILENAME="open-test-reporting-schema.jar"
	JAVA_RESOURCE_DIRS="schema/src/main/resources"
	JAVA_SRC_DIR="schema/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":open-test-reporting-schema.jar"
	rm -r target || die

	einfo "open-test-reporting-events.jar"
	JAVA_AUTOMATIC_MODULE_NAME="org.opentest4j.reporting.events"
	JAVA_JAR_FILENAME="open-test-reporting-events.jar"
	JAVA_RESOURCE_DIRS=()
	JAVA_SRC_DIR="events/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":open-test-reporting-events.jar"
	rm -r target || die

	use doc && ejavadoc
}

src_install() {
	java-pkg_dojar "open-test-reporting-schema.jar"
	java-pkg-simple_src_install

	if use source; then
		java-pkg_dosrc "schema/src/main/java/*"
		java-pkg_dosrc "events/src/main/java/*"
	fi
}
