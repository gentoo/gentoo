# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5 verify-sig

DESCRIPTION="The Apache Log4j API"
HOMEPAGE="https://logging.apache.org/log4j/2.x/"
SRC_URI="mirror://apache/logging/log4j/${PV}/apache-log4j-${PV}-src.zip
	verify-sig? ( https://downloads.apache.org/logging/log4j/${PV}/apache-log4j-${PV}-src.zip.asc )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"
RESTRICT="test"	# Too many test-dependencies not packaged.

BDEPEND="
	app-arch/unzip
	verify-sig? ( >=sec-keys/openpgp-keys-apache-logging-20251104 )
"

DEPEND="
	dev-java/bnd-annotation:0
	dev-java/error-prone-annotations:0
	dev-java/findbugs-annotations:0
	dev-java/jspecify:0
	dev-java/osgi-annotation:0
	dev-java/osgi-core:0
	>=virtual/jdk-11:*
	test? (
		>=dev-java/asm-9.9:0
		>=dev-java/assertj-core-3.27.6:0
		>=dev-java/byte-buddy-1.17.8:0
		>=dev-java/hamcrest-3.0:0
		>=dev-java/jna-5.18.1:0
		>=dev-java/jsr305-3.0.2-r1:0
		>=dev-java/junit-pioneer-1.9.1-r1:0
		>=dev-java/mockito-5.20.0:0
		>=dev-java/opentest4j-1.3.0-r1:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_CLASSPATH_EXTRA="bnd-annotation error-prone-annotations findbugs-annotations jspecify osgi-annotation osgi-core"
JAVA_INTERMEDIATE_JAR_NAME="org.apache.logging.log4j"
JAVA_MODULE_INFO_OUT="log4j-api-java9/src/main/java"
JAVA_RELEASE_SRC_DIRS=( ["9"]="log4j-api-java9/src/main/java" )
JAVA_RESOURCE_DIRS="log4j-api/src/main/resources"
JAVA_SRC_DIR="log4j-api/src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="asm assertj-core byte-buddy hamcrest jna jsr305 junit-pioneer junit-5 mockito opentest4j"
JAVA_TEST_RESOURCE_DIRS=( log4j-api-test/src/{main,test}/resources )
JAVA_TEST_SRC_DIR=( log4j-api-test/src/{main,test}/java )
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/logging.apache.org.asc"

src_prepare() {
	java-pkg-2_src_prepare
	mkdir -p log4j-api/src/main/resources/META-INF/services || die "mkdir"
	echo "org.apache.logging.log4j.util.EnvironmentPropertySource" \
		> log4j-api/src/main/resources/META-INF/services/org.apache.logging.log4j.util.PropertySource \
		|| die "META-INF/services"
	echo "org.apache.logging.log4j.util.SystemPropertiesPropertySource" \
		>> log4j-api/src/main/resources/META-INF/services/org.apache.logging.log4j.util.PropertySource \
		|| die "META-INF/services"
}

src_compile() {
	java-pkg-simple_src_compile
	# Remove unneeded classes and repackage according to log4j-api-java9/src/assembly/java9.xml
	rm log4j-api.jar || die
	rm target/classes/META-INF/versions/9/org/apache/logging/log4j/Dummy.class || die
	rm -r target/classes/META-INF/versions/9/org/apache/logging/log4j/{message,simple,spi,status} || die
	rm target/classes/META-INF/versions/9/org/apache/logging/log4j/util/EnvironmentPropertySource.class || die
	rm target/classes/META-INF/versions/9/org/apache/logging/log4j/util/LoaderUtil.class || die
	rm target/classes/META-INF/versions/9/org/apache/logging/log4j/util/PrivateSecurityManagerStackTraceUtil.class || die
	rm target/classes/META-INF/versions/9/org/apache/logging/log4j/util/PropertySource.class || die
	rm target/classes/META-INF/versions/9/org/apache/logging/log4j/util/SystemPropertiesPropertySource.class || die
	rm target/classes/META-INF/versions/9/org/apache/logging/log4j/util/internal/SerializationUtil.class || die
	mv target/classes/{META-INF/versions/9/,}module-info.class || die
	echo 'Multi-Release: true' >> target/classes/META-INF/MANIFEST.MF || die "add true"
	jar cfm log4j-api.jar target/classes/META-INF/MANIFEST.MF -C target/classes . || die
}
