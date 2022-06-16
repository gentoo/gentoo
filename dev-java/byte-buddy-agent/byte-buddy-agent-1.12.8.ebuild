# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom byte-buddy-agent-1.12.8.pom --download-uri https://repo1.maven.org/maven2/net/bytebuddy/byte-buddy-agent/1.12.8/byte-buddy-agent-1.12.8-sources.jar --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild byte-buddy-agent-1.12.8.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="net.bytebuddy:byte-buddy-agent:1.12.8"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Offers convenience for attaching an agent to the local or a remote VM"
HOMEPAGE="https://bytebuddy.net/"
SRC_URI="https://repo1.maven.org/maven2/net/bytebuddy/${PN}/${PV}/${P}-sources.jar
	test? ( https://codeload.github.com/raphw/byte-buddy/tar.gz/byte-buddy-1.12.8 -> byte-buddy-${PV}.tar.gz )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"

# Compile dependencies
# POM: ${P}.pom
# com.google.code.findbugs:findbugs-annotations:3.0.1 -> >=dev-java/findbugs-annotations-3.0.1:0
# com.google.code.findbugs:jsr305:3.0.2 -> >=dev-java/jsr305-3.0.2:0
# net.java.dev.jna:jna:5.8.0 -> >=dev-java/jna-5.10.0:4
# net.java.dev.jna:jna-platform:5.8.0 -> !!!artifactId-not-found!!!

DEPEND="
	>=virtual/jdk-1.8:*
	dev-java/findbugs-annotations:0
	dev-java/jna:4
	test? ( dev-java/mockito:4 )
"

RDEPEND="
	>=virtual/jre-1.8:*
"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"

JAVA_CLASSPATH_EXTRA="findbugs-annotations,jna-4"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4,mockito-4"
JAVA_TEST_SRC_DIR="src/test/java"

# 1) testSystemProperties(net.bytebuddy.agent.VirtualMachineAttachmentTest)
# java.lang.reflect.InvocationTargetException
# --
# Caused by: java.lang.UnsatisfiedLinkError: Native library (com/sun/jna/linux-x86-64/libjnidispatch.so) not found in resource path (target/test-classes:byte-buddy-agent.jar:/usr/share/findbugs-annotations/lib/findbugs-annotations.jar:/usr/share/jna-4/lib/jna.jar:/usr/share/jna-4/lib/jna-platform.jar:/usr/share/jsr305/lib/jsr305.jar:/usr/share/junit-4/lib/junit.jar:/usr/share/mockito-4/lib/mockito.jar:/usr/share/hamcrest-core-1.3/lib/hamcrest-core.jar:/usr/share/byte-buddy/lib/byte-buddy.jar:/usr/share/byte-buddy-agent/lib/byte-buddy-agent.jar:/usr/share/objenesis/lib/objenesis.jar:/usr/share/opentest4j/lib/opentest4j.jar:/usr/share/junit-4/lib/junit.jar:/usr/share/hamcrest-core-1.3/lib/hamcrest-core.jar)
#         at com.sun.jna.Native.loadNativeDispatchLibraryFromClasspath(Native.java:1059)
# --
# 2) testAgentProperties(net.bytebuddy.agent.VirtualMachineAttachmentTest)
# java.lang.reflect.InvocationTargetException
# --
# Caused by: java.lang.NoClassDefFoundError: Could not initialize class com.sun.jna.Native
#         at net.bytebuddy.agent.VirtualMachine$ForHotSpot$Connection$ForJnaPosixSocket$Factory.<init>(VirtualMachine.java:879)
# --
# 3) testMultipleProperties(net.bytebuddy.agent.VirtualMachineAttachmentTest)
# java.lang.reflect.InvocationTargetException
# --
# Caused by: java.lang.NoClassDefFoundError: Could not initialize class com.sun.jna.Native
#         at net.bytebuddy.agent.VirtualMachine$ForHotSpot$Connection$ForJnaPosixSocket$Factory.<init>(VirtualMachine.java:879)
# --
# 4) testAttachment(net.bytebuddy.agent.VirtualMachineAttachmentTest)
# java.lang.reflect.InvocationTargetException
# --
# Caused by: java.lang.NoClassDefFoundError: Could not initialize class com.sun.jna.Native
#         at net.bytebuddy.agent.VirtualMachine$ForHotSpot$Connection$ForJnaPosixSocket$Factory.<init>(VirtualMachine.java:879)
# --
# FAILURES!!!
# Tests run: 51,  Failures: 4
JAVA_TEST_EXCLUDES="net.bytebuddy.agent.VirtualMachineAttachmentTest"

src_prepare() {
	default
	mkdir -p "src/main/java" || die
	mv "net" "src/main/java" || die
	if use test; then
		mv "byte-buddy-byte-buddy-${PV}/byte-buddy-agent/src/test" "src" || die
	fi
}
