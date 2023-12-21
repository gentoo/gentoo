# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.google.guava:guava-testlib:${PV}-jre"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A set of java classes to assist the tests for Guava itself"
HOMEPAGE="https://github.com/google/guava"
# Currently we bundle the binary version of truth.jar used only for tests, we don't install it.
SRC_URI="https://github.com/google/guava/archive/v${PV}.tar.gz -> guava-${PV}.tar.gz
	test? ( https://repo1.maven.org/maven2/com/google/truth/truth/1.1.5/truth-1.1.5.jar )"
S="${WORKDIR}/guava-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

CP_DEPEND="
	>=dev-java/error-prone-annotations-2.24.0:0
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

src_test() {
	JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/truth-1.1.5.jar:testdata.jar"
	java-pkg-simple_src_test
}
