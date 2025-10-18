# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="TestParameterInjector For JUnit4"
HOMEPAGE="https://github.com/google/testparameterinjector"
SRC_URI="https://github.com/google/TestParameterInjector/archive//v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/TestParameterInjector-${PV}/junit4"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

CP_DEPEND="
	dev-java/auto-value:0
	>=dev-java/guava-33.4.8:0
	dev-java/jsr305:0
	dev-java/junit:4
	dev-java/snakeyaml:0
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
	dev-java/escapevelocity:0
	dev-java/incap:0
	dev-java/javapoet:0
	test? (
		>=dev-java/protobuf-java-4.30.2:0
		dev-java/truth:0
	)
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_CLASSPATH_EXTRA="jsr305,junit-4,snakeyaml"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4,protobuf-java,truth"
JAVA_TEST_SRC_DIR="src/test/java"

src_compile() {
	# get processorpath
	local pp="$(java-pkg_getjar auto-value auto-value.jar)"
	pp="${pp}:$(java-pkg_getjar auto-value auto-common.jar)"
	pp="${pp}:$(java-pkg_getjars --build-only escapevelocity,guava,incap,javapoet)"

	JAVAC_ARGS="-processorpath ${pp} -s src/main/java -parameters"

	java-pkg-simple_src_compile
}
