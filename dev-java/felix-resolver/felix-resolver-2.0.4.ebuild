# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri mirror://apache/felix/org.apache.felix.resolver-2.0.4-source-release.tar.gz --slot 0 --keywords "~amd64" --ebuild felix-resolver-2.0.4.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.felix:org.apache.felix.resolver:2.0.4"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Provide OSGi resolver service."
HOMEPAGE="https://felix.apache.org/documentation/index.html"
SRC_URI="mirror://apache/felix/org.apache.${PN//-/.}-${PV}-source-release.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm"

# Common dependencies
# POM: pom.xml
# org.osgi:org.osgi.core:5.0.0 -> >=dev-java/osgi-core-api-5.0.0:0
# org.osgi:osgi.annotation:6.0.1 -> >=dev-java/osgi-annotation-8.1.0:0

CP_DEPEND="
	dev-java/osgi-annotation:0
	dev-java/osgi-core:0
"

# Compile dependencies
# POM: pom.xml
# test? junit:junit:4.11 -> >=dev-java/junit-4.13.2:4
# test? org.apache.felix:org.apache.felix.utils:1.8.0 -> >=dev-java/felix-utils-1.11.8:0
# test? org.mockito:mockito-all:1.10.19 -> !!!artifactId-not-found!!!

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
	test? (
		dev-java/felix-utils:0
		dev-java/mockito:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

DOCS=( DEPENDENCIES NOTICE doc/changelog.txt )

S="${WORKDIR}/org.apache.felix.resolver-${PV}"

JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="felix-utils,junit-4,mockito"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_test() {
	# java.lang.ClassFormatError accessible: module java.base does not "opens java.lang" to unnamed module @73ec6027
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 17; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.lang=ALL-UNNAMED )
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.io=ALL-UNNAMED )
	fi
	java-pkg-simple_src_test
}
