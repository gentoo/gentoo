# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="OpenTelemetry Context (Incubator)"
HOMEPAGE="https://opentelemetry.io/"
SRC_URI="https://github.com/open-telemetry/opentelemetry-java/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"	# too many test-dependencies still missing

CP_DEPEND="
	dev-java/auto-value:0
	dev-java/jsr305:0
"

DEPEND="
	${CP_DEPEND}
	>=dev-java/error-prone-annotations-2.41.0:0
	dev-java/escapevelocity:0
	>=dev-java/guava-33.4.8:0
	dev-java/incap:0
	dev-java/javapoet:0
	>=virtual/jdk-1.8:*
	test? (
		dev-java/assertj-core:3
		dev-java/mockito:4
		dev-java/slf4j-api:0
	)
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_CLASSPATH_EXTRA="error-prone-annotations guava incap javapoet"
JAVADOC_CLASSPATH="auto-value error-prone-annotations jsr305"
JAVADOC_SRC_DIRS=( api/all/src/main/java context/src/main/java )

src_prepare() {
	java-pkg-2_src_prepare
	mkdir -p context/src/main/resources/io/opentelemetry/{api/all,context} || die
	echo "sdk.version=${PV}" > context/src/main/resources/io/opentelemetry/context/version.properties || die
	echo "sdk.version=${PV}" > context/src/main/resources/io/opentelemetry/api/all/version.properties || die
}

src_compile() {
	einfo "Compiling opentelemetry-context.jar"
	JAVA_AUTOMATIC_MODULE_NAME="io.opentelemetry.context"
	JAVA_JAR_FILENAME="opentelemetry-context.jar"
	JAVA_RESOURCE_DIRS="context/src/main/resources"
	JAVA_SRC_DIR="context/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":opentelemetry-context.jar"
	rm -r target || die

	# get processorpath
	local pp="$(java-pkg_getjar --build-only auto-value auto-value.jar)"
	pp="${pp}:$(java-pkg_getjar --build-only auto-value auto-common.jar)"
	pp="${pp}:$(java-pkg_getjars --build-only escapevelocity,guava,incap,javapoet)"

	einfo "Compiling opentelemetry-api.jar"
	JAVAC_ARGS=" -processorpath ${pp} -s api/all/src/main/java"
	JAVA_AUTOMATIC_MODULE_NAME="io.opentelemetry.api"
	JAVA_JAR_FILENAME="opentelemetry-api.jar"
	JAVA_RESOURCE_DIRS="api/all/src/main/resources"
	JAVA_SRC_DIR="api/all/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":opentelemetry-api.jar"
	rm -r target || die

	use doc && ejavadoc
}

src_test() {
	JAVA_TEST_GENTOO_CLASSPATH="assertj-core-3 junit-5 mockito-4 slf4j-api"
	JAVA_TEST_SRC_DIR="context/src/test/java"
	java-pkg-simple_src_test
}

src_install() {
	java-pkg_dojar opentelemetry-context.jar
	java-pkg-simple_src_install
}
