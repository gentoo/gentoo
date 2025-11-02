# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"
MAVEN_ID="com.google.guava:guava-testlib:${PV}-jre"

inherit java-pkg-2 java-pkg-simple check-reqs

DESCRIPTION="A set of java classes to assist the tests for Guava itself"
HOMEPAGE="https://github.com/google/guava"
SRC_URI="https://github.com/google/guava/archive/v${PV}.tar.gz -> guava-${PV}.tar.gz"
S="${WORKDIR}/guava-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

CP_DEPEND="
	>=dev-java/error-prone-annotations-2.42.0:0
	~dev-java/guava-${PV}:0
	dev-java/jspecify:0
	dev-java/junit:4
"

DEPEND="
	${CP_DEPEND}
	>=dev-java/checker-framework-qual-3.51.1:0
	dev-java/jsr305:0
	>=dev-java/j2objc-annotations-3.1:0
	>=virtual/jdk-11:*
	test? ( dev-java/truth:0 )
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_CLASSPATH_EXTRA="checker-framework-qual jsr305 j2objc-annotations"
JAVA_INTERMEDIATE_JAR_NAME="com.google.common.testlib"
JAVA_RELEASE_SRC_DIRS=( ["9"]="guava-testlib/src9" )
JAVA_SRC_DIR="${PN}/src"
JAVA_TEST_GENTOO_CLASSPATH="junit-4 truth"
JAVA_TEST_SRC_DIR="${PN}/test"

check_env() {
	if use test; then
		# this is needed only for tests
		CHECKREQS_MEMORY="1024M"
		check-reqs_pkg_pretend
	fi
}

pkg_pretend() {
	check_env
}

pkg_setup() {
	check_env
	java-pkg-2_pkg_setup
}

src_prepare() {
	java-pkg-2_src_prepare
	mkdir guava-testlib/src9 || die "mkdir"
	mv guava-testlib/src{,9}/module-info.java || die "mv module-info"
}

src_test() {
	JAVA_TEST_EXTRA_ARGS="-Xmx${CHECKREQS_MEMORY}"
	java-pkg-simple_src_test
}
