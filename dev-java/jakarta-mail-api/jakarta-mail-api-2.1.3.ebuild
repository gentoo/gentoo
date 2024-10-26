# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="jakarta.mail:jakarta.mail-api:2.1.3"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta Mail API 2.1 Specification API"
HOMEPAGE="https://jakartaee.github.io/mail-api/"
SRC_URI="https://github.com/jakartaee/mail-api/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/mail-api-${PV}/api"

LICENSE="EPL-1.0 EPL-2.0 GPL-2-with-classpath-exception"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64"

DEPEND="
	dev-java/jakarta-activation-api:2
	>=virtual/jdk-11:*
	test? (
		dev-java/angus-activation:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( ../{CONTRIBUTING,NOTICE,README}.md )

JAVA_CLASSPATH_EXTRA="jakarta-activation-api-2"
JAVA_SRC_DIR="src/main/"

JAVA_TEST_GENTOO_CLASSPATH="junit-4,angus-activation"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"

src_test() {
	# bug #853151 - copying from target/classes as a workaraound
	# handing of module-info.java in java-pkg-simple_src_test seems not aware of target/classes
	mkdir -p generated-test/jakarta/mail || die
	cp -r {target/classes,generated-test}/jakarta/mail/event || die
	cp -r {target/classes,generated-test}/jakarta/mail/util || die
	cp -r target/classes/jakarta/mail/Provider* generated-test/jakarta/mail || die

	# These tests need to run separately, otherwise would fail
	JAVA_TEST_EXCLUDES=(
		jakarta.mail.internet.ContentDispositionNoStrictTest
		jakarta.mail.internet.WindowsFileNamesTest
		jakarta.mail.internet.AppleFileNamesTest
	)
	java-pkg-simple_src_test

	JAVA_TEST_RUN_ONLY="jakarta.mail.internet.ContentDispositionNoStrictTest"
	java-pkg-simple_src_test

	JAVA_TEST_RUN_ONLY="jakarta.mail.internet.WindowsFileNamesTest"
	java-pkg-simple_src_test

	JAVA_TEST_RUN_ONLY="jakarta.mail.internet.AppleFileNamesTest"
	java-pkg-simple_src_test
}
