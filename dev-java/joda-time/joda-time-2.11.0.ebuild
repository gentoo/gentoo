# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/JodaOrg/joda-time/archive/v2.11.0.tar.gz --slot 0 --keywords "~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris" --ebuild joda-time-2.11.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="joda-time:joda-time:2.11.0"
JAVA_TESTING_FRAMEWORKS="junit"

inherit edo java-pkg-2 java-pkg-simple

DESCRIPTION="Date and time library to replace JDK date handling"
HOMEPAGE="https://www.joda.org/joda-time/"
SRC_URI="https://github.com/JodaOrg/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"

# Common dependencies
# POM: pom.xml
# org.joda:joda-convert:1.9.2 -> >=dev-java/joda-convert-2.2.2:0

CP_DEPEND="dev-java/joda-convert:0"

DEPEND=">=virtual/jdk-1.8:*
	${CP_DEPEND}"

RDEPEND=">=virtual/jre-1.8:*
	${CP_DEPEND}"

PATCHES=(
	# Enable tests for jdk-11 in
	# src/test/java/org/joda/time/TestDateTimeZone.java
	"${FILESDIR}/joda-time-2.11.0-test.patch"
)

DOCS=( NOTICE.txt README.md RELEASE-NOTES.txt )

S="${WORKDIR}/${P}"

JAVA_AUTOMATIC_MODULE_NAME="org.joda.time"
JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/res"

JAVA_TEST_GENTOO_CLASSPATH="junit"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_RUN_ONLY="org.joda.time.TestAllPackages"

src_prepare() {
	default
	# move .properties files to JAVA_RESOURCE_DIRS
	mkdir -p src/main/res
	cp -r src/main/{java/*,res} || die
	find src/main/res -type f ! -name '*.properties' -exec rm -rf {} + || die
}

src_compile() {
	java-pkg-simple_src_compile

	# Generate the missing "org/joda/time/tz/data/ZoneInfoMap"
	# Arguments from https://github.com/JodaOrg/joda-time/blob/v2.10.10/pom.xml#L413-L427
	edo "$(java-config -J)" \
		-cp ${PN}.jar \
		org.joda.time.tz.ZoneInfoCompiler \
		-src "${JAVA_SRC_DIR}/org/joda/time/tz/src" \
		-dst "${P}/src/main/resources/org/joda/time/tz/data" \
		africa \
		antarctica \
		asia \
		australasia \
		europe \
		northamerica \
		southamerica \
		etcetera \
		backward

	java-pkg_addres ${PN}.jar "${P}"/src/main/resources
}

src_test() {
	# There are test failures in
	# src/test/java/org/joda/time/TestDateTimeZone.java
	# with jdk higher than 11
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -le 11 ; then
		java-pkg-simple_src_test
	else
		einfo "Tests restricted to <=jdk-11"
	fi
}
