# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Fluent assertions for Java and Android"
HOMEPAGE="https://truth.dev/"
SRC_URI="https://github.com/google/truth/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64"

DEPEND="
	dev-java/asm:0
	dev-java/auto-value:0
	dev-java/escapevelocity:0
	>=dev-java/guava-33.4.8:0
	>=dev-java/guava-testlib-33.4.8:0
	dev-java/incap:0
	dev-java/javapoet:0
	dev-java/jspecify:0
	dev-java/junit:4
	>=virtual/jdk-1.8:*
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_CLASSPATH_EXTRA="asm,auto-value,guava,jspecify,junit-4"
JAVA_SRC_DIR="core/src/main/java"
JAVA_TEST_EXCLUDES=(
	com.google.common.truth.BaseSubjectTestCase	# No runnable methods
	com.google.common.truth.PlatformBaseSubjectTestCase	# No runnable methods
	com.google.common.truth.TestCorrespondences	# No runnable methods
	com.google.common.truth.TestPlatform	# No runnable methods
	com.google.common.truth.NoJUnitTest	# No runnable methods
	com.google.common.truth.ActualValueInferenceTest # run it in a second step
)
JAVA_TEST_GENTOO_CLASSPATH="guava-testlib,junit-4"
JAVA_TEST_SRC_DIR="core/src/test/java"

src_prepare() {
	java-pkg-2_src_prepare
	rm -r core/src/{main,test}/java/com/google/common/truth/super || die "remove super"
	rm -r core/src/test/java/com/google/common/truth/gwt || die "remove gwt"
}

src_compile() {
	# get processorpath
	local pp="$(java-pkg_getjar --build-only auto-value auto-value.jar)"
	pp="${pp}:$(java-pkg_getjar --build-only auto-value auto-common.jar)"
	pp="${pp}:$(java-pkg_getjars --build-only escapevelocity,guava,incap,javapoet)"

	JAVAC_ARGS=" -processorpath ${pp} -s core/src/main/java"

	java-pkg-simple_src_compile
}

src_test() {
	JAVA_TEST_RUN_ONLY=( com.google.common.truth.ActualValueInferenceTest )
	JAVA_TEST_EXTRA_ARGS=( -Dcom.google.common.truth.enable_infer_description_for_expect_failure=true )
	java-pkg-simple_src_test
	JAVA_TEST_RUN_ONLY=()
	JAVA_TEST_EXTRA_ARGS=( -Dcom.google.common.truth.enable_infer_description_for_expect_failure=false )
	java-pkg-simple_src_test
}
