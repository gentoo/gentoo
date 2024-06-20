# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.google.guava:guava-testlib:${PV}-jre"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple check-reqs

DESCRIPTION="A set of java classes to assist the tests for Guava itself"
HOMEPAGE="https://github.com/google/guava"
# Currently we bundle the binary version of truth.jar used only for tests, we don't install it.
SRC_URI="https://github.com/google/guava/archive/v${PV}.tar.gz -> guava-${PV}.tar.gz
	test? ( https://repo1.maven.org/maven2/com/google/truth/truth/1.4.2/truth-1.4.2.jar )"
S="${WORKDIR}/guava-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"

CP_DEPEND="
	>=dev-java/error-prone-annotations-2.27.1:0
	~dev-java/guava-${PV}:0
	dev-java/jsr305:0
	dev-java/junit:4
"

DEPEND="${CP_DEPEND}
	dev-java/checker-framework-qual:0
	dev-java/j2objc-annotations:0
	>=virtual/jdk-1.8:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

JAVA_CLASSPATH_EXTRA="checker-framework-qual j2objc-annotations"
JAVA_SRC_DIR="${PN}/src"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
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

src_test() {
	JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/truth-1.4.2.jar:testdata.jar"
	JAVA_TEST_EXTRA_ARGS="-Xmx${CHECKREQS_MEMORY}"
	java-pkg-simple_src_test
}
