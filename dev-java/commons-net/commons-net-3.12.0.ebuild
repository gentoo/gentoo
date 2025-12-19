# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="commons-net:commons-net:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5 verify-sig

DESCRIPTION="Client-oriented Java library to implement many Internet protocols"
HOMEPAGE="https://commons.apache.org/proper/commons-net/"
FSV="1.2.1"	# apache-ftpserver isn't yet packaged
MCV="2.2.4"
SRC_URI="mirror://apache/commons/net/source/${P}-src.tar.gz
	test? (
		https://repo1.maven.org/maven2/org/apache/ftpserver/ftpserver-core/${FSV}/ftpserver-core-${FSV}.jar
		https://repo1.maven.org/maven2/org/apache/ftpserver/ftplet-api/${FSV}/ftplet-api-${FSV}.jar
		https://repo1.maven.org/maven2/org/apache/mina/mina-core/${MCV}/mina-core-${MCV}.jar
	)
	verify-sig? ( https://downloads.apache.org/commons/net/source/${P}-src.tar.gz.asc )"
S="${WORKDIR}/${P}-src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 ~x64-macos ~x64-solaris"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-ggregory )"

DEPEND="
	>=dev-java/commons-io-2.20.0:0
	>=virtual/jdk-11:*
	test? (
		>=dev-java/commons-collections-4.5.0:4
		>=dev-java/commons-lang-3.18.0:0
		dev-java/junit:4
		dev-java/opentest4j:0
		dev-java/slf4j-api:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( CONTRIBUTING.md {NOTICE,RELEASE-NOTES}.txt )
PATCHES=( "${FILESDIR}/commons-net-3.12.0-skipFailingTests.patch" )

JAVA_CLASSPATH_EXTRA="commons-io"
JAVA_GENTOO_CLASSPATH_EXTRA=:"${DISTDIR}/ftplet-api-${FSV}.jar"
JAVA_GENTOO_CLASSPATH_EXTRA+=:"${DISTDIR}/ftpserver-core-${FSV}.jar"
JAVA_GENTOO_CLASSPATH_EXTRA+=:"${DISTDIR}/mina-core-${MCV}.jar"
JAVA_INTERMEDIATE_JAR_NAME="org.apache.${PN/-/.}"
JAVA_MODULE_INFO_OUT="src/main"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="commons-collections-4 commons-lang junit-4 junit-5 opentest4j slf4j-api"
JAVA_TEST_RESOURCE_DIRS="src/test/resources"
JAVA_TEST_SRC_DIR="src/test/java"
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/ggregory.asc"

src_unpack() {
	use verify-sig && verify-sig_verify_detached "${DISTDIR}"/${P}-src.tar.gz{,.asc}
	default
}

src_prepare() {
	default #780585
	java-pkg-2_src_prepare

	# pom.xml lines 179-188 (do not put it in the main jar)
	mkdir -p src/examples/java/org/apache/commons/net/ || die
	mv src/{main,examples}/java/org/apache/commons/net/examples || die "mv java"
	mkdir -p target/examples || die
	mv {src/main/resources,target/examples}/org || die "mv resources"
}

src_test() {
	# Some examples are needed only for compiling tests but won't be packaged.
	mkdir -p target/examples || die
	local examples_sources
	find src/examples/java -type f -name '*.java' \
		> examples_sources || die "sources"
	ejavac -d target/examples @examples_sources \
		-classpath "$(java-pkg_getjars --build-only commons-io)":commons-net.jar
	JAVA_GENTOO_CLASSPATH_EXTRA+=":target/examples"

	# src/test/java/org/apache/commons/net/util/SubnetUtilsTest.java:39: error: cannot find symbol
	# import org.junit.jupiter.params.provider.FieldSource;
	rm src/test/java/org/apache/commons/net/util/SubnetUtilsTest.java || die "rm SubnetUtilsTest.java"

	# pom.xml lines 208-209
	find src/test/java -type f -name '*FunctionalTest.java' -delete || die
	find src/test/java -type f -name 'POP3*Test.java' -delete || die

	JAVA_TEST_EXCLUDES=(
		# caught: java.net.UnknownHostException:
		# jdk.internal.util.Exceptions$NonSocketInfo@32f61a31tux: Name or service not known
		org.apache.commons.net.tftp.TFTPAckPacketTest
		org.apache.commons.net.tftp.TFTPDataPacketTest
		org.apache.commons.net.tftp.TFTPErrorPacketTest
		org.apache.commons.net.tftp.TFTPReadRequestPacketTest
		org.apache.commons.net.tftp.TFTPRequestPacketTest
		org.apache.commons.net.tftp.TFTPWriteRequestPacketTest
	)
	junit5_src_test
}
