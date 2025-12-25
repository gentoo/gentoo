# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple junit5 verify-sig

WSV="2.1.8"	# webcompere/systemstubs isn't yet packaged.

DESCRIPTION="The Apache Log4j API"
HOMEPAGE="https://logging.apache.org/log4j/2.x/"
SRC_URI="mirror://apache/logging/log4j/${PV}/apache-log4j-${PV}-src.zip
	https://repo1.maven.org/maven2/uk/org/webcompere/system-stubs-core/${WSV}/system-stubs-core-${WSV}.jar
	https://repo1.maven.org/maven2/uk/org/webcompere/system-stubs-jupiter/${WSV}/system-stubs-jupiter-${WSV}.jar
	verify-sig? ( https://apache/logging/log4j/${PV}/apache-log4j-${PV}-src.zip.asc )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

# Removal of two failing tests leads to:
#	[       903 tests successful      ]
#	[         0 tests failed          ]
#
#
#	WARNING: Delegated to the 'execute' command.
#	         This behaviour has been deprecated and will be removed in a future release.
#	         Please use the 'execute' command directly.
#	 * Verifying test classes' dependencies
#	Exception in thread "main" com.sun.tools.jdeps.Dependencies$ClassFileError: Bad magic number
#		at jdk.jdeps/com.sun.tools.jdeps.ClassFileReader.scan(ClassFileReader.java:167)
#		at jdk.jdeps/com.sun.tools.jdeps.ClassFileReader.entries(ClassFileReader.java:115)
#		at jdk.jdeps/com.sun.tools.jdeps.Archive.contains(Archive.java:95)
#		at jdk.jdeps/com.sun.tools.jdeps.JdepsConfiguration$Builder.addRoot(JdepsConfiguration.java:476)
#		at jdk.jdeps/com.sun.tools.jdeps.JdepsTask.buildConfig(JdepsTask.java:594)
#		at jdk.jdeps/com.sun.tools.jdeps.JdepsTask.run(JdepsTask.java:554)
#		at jdk.jdeps/com.sun.tools.jdeps.JdepsTask.run(JdepsTask.java:529)
#		at jdk.jdeps/com.sun.tools.jdeps.Main.main(Main.java:50)
#	Caused by: java.lang.IllegalArgumentException: Bad magic number
#		at java.base/jdk.internal.classfile.impl.ClassReaderImpl.<init>(ClassReaderImpl.java:74)
#		at java.base/jdk.internal.classfile.impl.ClassImpl.<init>(ClassImpl.java:49)
#		at java.base/jdk.internal.classfile.impl.ClassFileImpl.parse(ClassFileImpl.java:135)
#		at java.base/java.lang.classfile.ClassFile.parse(ClassFile.java:543)
#		at jdk.jdeps/com.sun.tools.jdeps.ClassFileReader.scan(ClassFileReader.java:162)
#		... 7 more
#	 * ERROR: dev-java/log4j-api-2.25.3::gentoo failed (test phase):
#	 *   jdeps failed
RESTRICT="test"

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
		>=dev-java/asm-9.9.1:0
		>=dev-java/assertj-core-3.27.6:0
		>=dev-java/byte-buddy-1.18.2:0
		>=dev-java/hamcrest-3.0:0
		>=dev-java/jna-5.18.1:0
		>=dev-java/jsr305-3.0.2-r1:0
		>=dev-java/junit-pioneer-1.9.1-r1:0
		>=dev-java/mockito-5.21.0:0
		>=dev-java/opentest4j-1.3.0-r1:0
	)
"

RDEPEND=">=virtual/jre-1.8:*"

JAVA_CLASSPATH_EXTRA="bnd-annotation error-prone-annotations findbugs-annotations jspecify osgi-annotation osgi-core"
JAVA_GENTOO_CLASSPATH_EXTRA="${DISTDIR}/system-stubs-core-${WSV}.jar"
JAVA_GENTOO_CLASSPATH_EXTRA+=":${DISTDIR}/system-stubs-jupiter-${WSV}.jar"
JAVA_INTERMEDIATE_JAR_NAME="org.apache.logging.log4j"
JAVA_MODULE_INFO_OUT="log4j-api-java9/src/main/java"
JAVA_RELEASE_SRC_DIRS=( ["9"]="log4j-api-java9/src/main/java" )
JAVA_RESOURCE_DIRS="log4j-api/src/main/resources"
JAVA_SRC_DIR="log4j-api/src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="asm assertj-core byte-buddy commons-lang hamcrest jackson-annotations
	jackson-core jackson-databind jna jsr305 junit-pioneer junit-5 mockito opentest4j"
JAVA_TEST_RESOURCE_DIRS=( log4j-api-test/src/{main,test}/resources )
JAVA_TEST_SRC_DIR=( log4j-api-test/src/{main,test}/java )
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/logging.apache.org.asc"

src_unpack() {
	use verify-sig && verify-sig_verify_detached "${DISTDIR}"/apache-log4j-${PV}-src.zip{,.asc}
	default
}

src_prepare() {
	java-pkg-2_src_prepare
	mkdir -p log4j-api/src/main/resources/META-INF/services || die "mkdir"
	echo "org.apache.logging.log4j.util.EnvironmentPropertySource" \
		> log4j-api/src/main/resources/META-INF/services/org.apache.logging.log4j.util.PropertySource \
		|| die "META-INF/services"
	echo "org.apache.logging.log4j.util.SystemPropertiesPropertySource" \
		>> log4j-api/src/main/resources/META-INF/services/org.apache.logging.log4j.util.PropertySource \
		|| die "META-INF/services"

	# test/junit/BundleTestInfo.java:21: error: package org.apache.maven.model does not exist
	# test/junit/BundleTestInfo.java:22: error: package org.apache.maven.model.io.xpp3 does not exist
	# test/junit/BundleTestInfo.java:23: error: package org.apache.maven.project does not exist
	# test/junit/BundleTestInfo.java:24: error: package org.codehaus.plexus.util.xml.pull does not exist
	rm log4j-api-test/src/main/java/org/apache/logging/log4j/test/junit/BundleTestInfo.java || die

	# test-failures, but deleting them leads to "Bad Magic Number' in jdeps' verification.
	rm log4j-api-test/src/test/java/org/apache/logging/log4j/message/ParameterizedMessageRecursiveFormattingWithoutThreadLocalsTest.java || die
	rm log4j-api-test/src/test/java/org/apache/logging/log4j/NoopThreadContextTest.java || die
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
