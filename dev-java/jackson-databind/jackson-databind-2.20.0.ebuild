# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5

JMV="0.9.1"
DESCRIPTION="General data-binding functionality for Jackson: works on core streaming API"
HOMEPAGE="https://github.com/FasterXML/jackson-databind"
SRC_URI="https://github.com/FasterXML/${PN}/archive/${P}.tar.gz
	test? ( https://repo1.maven.org/maven2/javax/measure/jsr-275/${JMV}/jsr-275-${JMV}.jar )"
S="${WORKDIR}/${PN}-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	~dev-java/jackson-annotations-$(ver_cut 1-2):0
	~dev-java/jackson-core-${PV}:0
"

DEPEND="
	${CP_DEPEND}
	|| ( virtual/jdk:25 virtual/jdk:21 virtual/jdk:17 virtual/jdk:11 )
	test? (
		>=dev-java/asm-9.8-r1:0
		>=dev-java/assertj-core-3.27.6:0
		dev-java/fastdoubleparser:0
		>=dev-java/guava-testlib-33.5.0:0
		>=dev-java/jol-core-0.17:0
		dev-java/junit:5[suite]
		>=dev-java/mockito-5.20.0:0
	)
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( {README,SECURITY}.md release-notes/{CREDITS,VERSION}-2.x )
PATCHES=(
	"${FILESDIR}/jackson-databind-2.20.0-NoClassDefFoundWorkaroundTest.patch"
	"${FILESDIR}/jackson-databind-2.20.0-JDKStringLikeTypeDeserTest.patch" 
	"${FILESDIR}/jackson-databind-2.20.0-JDKTypeSerializationTest.patch"
)

JAVA_GENTOO_CLASSPATH_EXTRA=( "${DISTDIR}/jsr-275-${JMV}.jar" )
JAVA_INTERMEDIATE_JAR_NAME="com.fasterxml.jackson.databind"
JAVA_RELEASE_SRC_DIRS=( ["9"]="src/moditect" )
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_EXTRA_ARGS=( -Djdk.attach.allowAttachSelf -Djol.magicFieldOffset=true )
JAVA_TEST_GENTOO_CLASSPATH="asm assertj-core fastdoubleparser guava-testlib jol-core mockito"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"

src_prepare() {
	default # bug #780585
	java-pkg-2_src_prepare

	sed -e 's:@package@:com.fasterxml.jackson.databind.cfg:g' \
		-e "s:@projectversion@:${PV}:g" \
		-e 's:@projectgroupid@:com.fasterxml.jackson.core:g' \
		-e "s:@projectartifactid@:${PN}:g" \
		"${JAVA_SRC_DIR}/com/fasterxml/jackson/databind/cfg/PackageVersion.java.in" \
		> "${JAVA_SRC_DIR}/com/fasterxml/jackson/databind/cfg/PackageVersion.java" || die

	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 17; then
		JAVA_TEST_EXTRA_ARGS+=( --add-opens=java.base/java.{lang,util}=ALL-UNNAMED )
	fi
}
