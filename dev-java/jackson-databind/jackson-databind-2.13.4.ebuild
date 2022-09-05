# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/FasterXML/jackson-databind/archive/jackson-databind-2.13.4.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild jackson-databind-2.13.4.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.fasterxml.jackson.core:jackson-databind:2.13.4"
# No tests because of not yet packaged powermock
# JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="General data-binding functionality for Jackson: works on core streaming API"
HOMEPAGE="https://github.com/FasterXML/jackson-databind"
SRC_URI="https://github.com/FasterXML/${PN}/archive/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

# Common dependencies
# POM: pom.xml
# com.fasterxml.jackson.core:jackson-annotations:2.13.4 -> >=dev-java/jackson-annotations-2.13.4:2
# com.fasterxml.jackson.core:jackson-core:2.13.4 -> >=dev-java/jackson-core-2.13.4:0

CP_DEPEND="
	~dev-java/jackson-annotations-${PV}:2
	~dev-java/jackson-core-${PV}:0
"

# Compile dependencies
# POM: pom.xml
# test? javax.measure:jsr-275:0.9.1 -> !!!groupId-not-found!!!
# test? junit:junit:4.13.1 -> >=dev-java/junit-4.13.2:4
# test? org.powermock:powermock-api-mockito2:2.0.0 -> !!!groupId-not-found!!!
# test? org.powermock:powermock-core:2.0.0 -> !!!groupId-not-found!!!
# test? org.powermock:powermock-module-junit4:2.0.0 -> !!!groupId-not-found!!!

DEPEND="
	>=virtual/jdk-11:*
	${CP_DEPEND}"
#	test? (
#		!!!groupId-not-found!!!
#	)
#"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}"

DOCS=( {README,SECURITY}.md release-notes/{CREDITS,VERSION}-2.x )

S="${WORKDIR}/${PN}-${P}"

JAVA_SRC_DIR=( "src/main/java" "src/moditect" )
JAVA_RESOURCE_DIRS="src/main/resources"

#	JAVA_TEST_GENTOO_CLASSPATH="!!!groupId-not-found!!!,junit-4,!!!groupId-not-found!!!,!!!groupId-not-found!!!,!!!groupId-not-found!!!"
#	JAVA_TEST_SRC_DIR="src/test/java"
#	JAVA_TEST_RESOURCE_DIRS=(
#		"src/test/resources"
#	)

src_prepare() {
	java-pkg-2_src_prepare

	sed -e 's:@package@:com.fasterxml.jackson.databind.cfg:g' \
		-e "s:@projectversion@:${PV}:g" \
		-e 's:@projectgroupid@:com.fasterxml.jackson.core:g' \
		-e "s:@projectartifactid@:${PN}:g" \
		"${JAVA_SRC_DIR}/com/fasterxml/jackson/databind/cfg/PackageVersion.java.in" \
		> "${JAVA_SRC_DIR}/com/fasterxml/jackson/databind/cfg/PackageVersion.java" || die
}
