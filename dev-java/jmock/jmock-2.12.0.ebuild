# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom jmock/pom.xml --download-uri https://github.com/jmock-developers/jmock-library/archive/2.12.0.tar.gz --slot 2 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild jmock-2.12.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.jmock:jmock:2.12.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="An expressive Mock Object library for Test Driven Development"
HOMEPAGE="http://jmock.org/"
SRC_URI="https://github.com/${PN}-developers/${PN}-library/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND="
	dev-java/asm:9
	dev-java/bsh:0
	dev-java/hamcrest:0
	>=virtual/jdk-1.8:*
	test? (
		dev-java/findbugs-annotations:0
		dev-java/jaxws-api:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/jmock-library-${PV}"

JAVA_TEST_GENTOO_CLASSPATH="
	findbugs-annotations
	jaxws-api
	junit-4
"
JAVA_TEST_SRC_DIR="jmock/src/test/java"

src_prepare() {
	default
	# We have "signed.jar" directly in ${S}, not in "../testjar/target/".
	sed \
		-e 's:\.\.\/testjar\/target\/\(signed.jar\):\1:' \
		-i jmock/src/test/java/org/jmock/test/unit/lib/JavaReflectionImposteriserTests.java || die
}

src_compile() {
	if use test; then
		einfo "Compiling testjar"
		JAVA_SRC_DIR="testjar/src/main/java"
		JAVA_CLASSPATH_EXTRA="findbugs-annotations"
		JAVA_JAR_FILENAME="signed.jar"
		java-pkg-simple_src_compile
		cp {,un}signed.jar || die
		JAVA_GENTOO_CLASSPATH_EXTRA+=":signed.jar:unsigned.jar"
		rm -r target || die
	fi

	einfo "Compiling jmock.jar"
	JAVA_SRC_DIR="jmock/src/main/java"
	JAVA_CLASSPATH_EXTRA="
		asm-9
		bsh
		hamcrest
	"
	JAVA_JAR_FILENAME="jmock.jar"
	java-pkg-simple_src_compile

	# Code generation according to jmock/pom.xml#L73-L90
	"$(java-config -J)"	\
		-cp $(java-config --with-dependencies --classpath asm:9):${PN}.jar \
		org.jmock.ExpectationsCreator

	# Update jmock.jar with updated Expectations.class
	jar ufv jmock.jar -C target/classes org/jmock/Expectations.class || die
}

src_test() {
	# ${S}/pom.xml#L131-L143
	pushd jmock/src/test/java || die
		local JAVA_TEST_RUN_ONLY=$(find * \
			\( -wholename "**/*Test.java" \
			-o -wholename '**/*Tests.java' \)\
			! -wholename "**/Failing*TestCase.java" \
			! -wholename "**/VerifyingTestCaseTests$*" \
			! -wholename "**/Abstract*Test.java" \
			)
	popd
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//.java}"
	JAVA_TEST_RUN_ONLY="${JAVA_TEST_RUN_ONLY//\//.}"
	java-pkg-simple_src_test
}
