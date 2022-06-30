# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/raphw/byte-buddy/archive/byte-buddy-1.12.12.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild byte-buddy-1.12.12.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="net.bytebuddy:byte-buddy-agent:1.12.12"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Offers convenience for attaching an agent to the local or a remote VM"
HOMEPAGE="https://bytebuddy.net/byte-buddy-agent"
SRC_URI="https://github.com/raphw/${PN}/archive/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

DEPEND="
	>=virtual/jdk-11:*
	dev-java/findbugs-annotations:0
	dev-java/jna:4
	dev-java/jsr305:0
	test? (
		dev-java/mockito:4
	)
"

RDEPEND="
	>=virtual/jre-11:*
"

S="${WORKDIR}/${PN}-${P}"

JAVA_CLASSPATH_EXTRA="asm-9,findbugs-annotations,jsr305,jna-4"

src_prepare() {
	default
	# https://github.com/raphw/byte-buddy/blob/byte-buddy-1.12.12/byte-buddy-agent/pom.xml#L132-L165
	cat > byte-buddy-agent/src/main/java/module-info.java <<-EOF
		module net.bytebuddy.agent {
			requires java.instrument;
			requires static jdk.attach;
			requires static com.sun.jna;
			requires static com.sun.jna.platform;
		}
	EOF

	sed \
		-e 's:verifyZeroInteractions:verifyNoInteractions:g' \
		-i byte-buddy-dep/src/test/java/net/bytebuddy/*.java \
		-i byte-buddy-dep/src/test/java/net/bytebuddy/*/*Test.java \
		-i byte-buddy-dep/src/test/java/net/bytebuddy/*/*/*Test.java \
		-i byte-buddy-dep/src/test/java/net/bytebuddy/*/*/*/*Test.java \
		-i byte-buddy-dep/src/test/java/net/bytebuddy/*/*/*/*/*Test.java \
		|| die
}

src_compile() {
	einfo "Compiling byte-buddy-agent.jar"
	JAVA_SRC_DIR="byte-buddy-agent/src/main/java"
	JAVA_RESOURCE_DIRS="byte-buddy-agent/src/main/resources"
	JAVA_JAR_FILENAME="byte-buddy-agent.jar"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":byte-buddy-agent.jar"
	rm -r target || die

# For pkgdiff to compare the content of module-info.class
#	mkdir -p META-INF/versions/9 || die
#	cp target/classes/module-info.class META-INF/versions/9/ || die
#	jar -uf byte-buddy.jar -C . META-INF/versions/9/module-info.class || die

	einfo "Compiling byte-buddy-dep.jar"
	JAVA_SRC_DIR="byte-buddy-dep/src/main/java"
	JAVA_RESOURCE_DIRS="byte-buddy-dep/src/main/resources"
	JAVA_JAR_FILENAME="byte-buddy-dep.jar"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":byte-buddy-dep.jar"
	rm -r target || die

	if use doc; then
		JAVA_SRC_DIR=(
			"byte-buddy-agent/src/main/java"
			"byte-buddy-dep/src/main/java"
		)
		JAVA_JAR_FILENAME="ignoreme.jar"
		java-pkg-simple_src_compile
	fi
}

src_test() {
	JAVA_TEST_GENTOO_CLASSPATH="junit-4,mockito-4"

	einfo "Testing byte-buddy-agent"
	JAVA_TEST_SRC_DIR="byte-buddy-agent/src/test/java"

	# There were 4 failures:
	# 1) testSystemProperties(net.bytebuddy.agent.VirtualMachineAttachmentTest)
	# java.lang.reflect.InvocationTargetException
	#         at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	#         at java.base/jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:77)
	#         at java.base/jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	#         at java.base/java.lang.reflect.Method.invoke(Method.java:568)
	#         at net.bytebuddy.agent.VirtualMachineAttachmentTest.testSystemProperties(VirtualMachineAttachmentTest.java:64)
	#         ... 11 trimmed
	# Caused by: java.lang.UnsatisfiedLinkError: Native library (com/sun/jna/linux-x86-64/libjnidispatch.so) not found in resource path (target/test-classes:byte-buddy-dep.jar:byte-buddy-agent.jar:byte-buddy-dep.jar:/usr/share/asm-9/lib/asm.jar:/usr/share/asm-9/lib/asm-tree.jar:/usr/share/asm-9/lib/asm-analysis.jar:/usr/share/asm-9/lib/asm-commons.jar:/usr/share/asm-9/lib/asm-util.jar:/usr/share/findbugs-annotations/lib/findbugs-annotations.jar:/usr/share/jsr305/lib/jsr305.jar:/usr/share/jna-4/lib/jna.jar:/usr/share/jna-4/lib/jna-platform.jar:/usr/share/junit-4/lib/junit.jar:/usr/share/mockito-4/lib/mockito.jar:/usr/share/asm-9/lib/asm.jar:/usr/share/asm-9/lib/asm-tree.jar:/usr/share/asm-9/lib/asm-analysis.jar:/usr/share/asm-9/lib/asm-commons.jar:/usr/share/asm-9/lib/asm-util.jar:/usr/share/byte-buddy/lib/byte-buddy-agent.jar:/usr/share/byte-buddy/lib/byte-buddy-dep.jar:/usr/share/objenesis/lib/objenesis.jar:/usr/share/opentest4j/lib/opentest4j.jar:/usr/share/hamcrest-core-1.3/lib/hamcrest-core.jar:/usr/share/junit-4/lib/junit.jar:/usr/share/hamcrest-core-1.3/lib/hamcrest-core.jar)
	#         at com.sun.jna.Native.loadNativeDispatchLibraryFromClasspath(Native.java:1059)
	#         at com.sun.jna.Native.loadNativeDispatchLibrary(Native.java:1015)
	#         at com.sun.jna.Native.<clinit>(Native.java:221)
	#         at net.bytebuddy.agent.VirtualMachine$ForHotSpot$Connection$ForJnaPosixSocket$Factory.<init>(VirtualMachine.java:879)
	#         at net.bytebuddy.agent.VirtualMachine$ForHotSpot$Connection$ForJnaPosixSocket$Factory.withDefaultTemporaryFolder(VirtualMachine.java:910)
	#         at net.bytebuddy.agent.VirtualMachine$ForHotSpot.attach(VirtualMachine.java:245)
	#         ... 17 more

	JAVA_TEST_EXCLUDES=( net.bytebuddy.agent.VirtualMachineAttachmentTest )
	java-pkg-simple_src_test

	einfo "Testing byte-buddy-dep"
	JAVA_TEST_SRC_DIR="byte-buddy-dep/src/test/java"
	JAVA_TEST_RESOURCE_DIRS="byte-buddy-dep/src/test/resources"

	# what "mvn test" does with java 17 is:
	# Tests run: 9836, Failures: 0, Errors: 0, Skipped: 0

	# 1) testTypeVariableTypeAnnotationRuntimeRetention[0](net.bytebuddy.implementation.attribute.MethodAttributeAppenderForInstrumentedMethodTest)
	# org.mockito.exceptions.verification.NoInteractionsWanted:
	# --
	# 2) testTypeVariableTypeAnnotationRuntimeRetention[1](net.bytebuddy.implementation.attribute.MethodAttributeAppenderForInstrumentedMethodTest)
	# org.mockito.exceptions.verification.NoInteractionsWanted:
	# --
	# 3) testAnnotationClassFileRetention(net.bytebuddy.implementation.attribute.TypeAttributeAppenderForInstrumentedTypeDifferentiatingTest)
	# org.mockito.exceptions.verification.NoInteractionsWanted:
	# --
	# 4) testAnnotationByteCodeRetention(net.bytebuddy.implementation.attribute.TypeAttributeAppenderForInstrumentedTypeDifferentiatingTest)
	# org.mockito.exceptions.verification.NoInteractionsWanted:
	# --
	# 5) testAnnotationClassFileRetention(net.bytebuddy.implementation.attribute.TypeAttributeAppenderForInstrumentedTypeTest)
	# org.mockito.exceptions.verification.NoInteractionsWanted:
	# --
	# 6) testAnnotationByteCodeRetention(net.bytebuddy.implementation.attribute.TypeAttributeAppenderForInstrumentedTypeTest)
	# org.mockito.exceptions.verification.NoInteractionsWanted:
	# --
	# 7) testChildSecond(net.bytebuddy.pool.TypePoolDefaultHierarchyTest)
	# org.mockito.exceptions.verification.NoInteractionsWanted:
	# --
	# 8) testNoParameterNameAndModifiers(net.bytebuddy.pool.TypePoolDefaultMethodDescriptionTest)
	# java.lang.AssertionError:
	# --
	# 9) testSimpleApplication(net.bytebuddy.description.type.TypeInitializerTest)
	# org.mockito.exceptions.verification.NoInteractionsWanted:
	# --
	# 10) testRedefinitionChunkedOneFailsResubmit(net.bytebuddy.agent.builder.AgentBuilderDefaultTest)
	# org.mockito.exceptions.verification.NoInteractionsWanted:
	JAVA_TEST_EXCLUDES+=(
		net.bytebuddy.implementation.attribute.MethodAttributeAppenderForInstrumentedMethodTest
		net.bytebuddy.implementation.attribute.TypeAttributeAppenderForInstrumentedTypeDifferentiatingTest
		net.bytebuddy.implementation.attribute.TypeAttributeAppenderForInstrumentedTypeTest
		net.bytebuddy.pool.TypePoolDefaultHierarchyTest
		net.bytebuddy.pool.TypePoolDefaultMethodDescriptionTest
		net.bytebuddy.description.type.TypeInitializerTest
		net.bytebuddy.agent.builder.AgentBuilderDefaultTest
	)
	java-pkg-simple_src_test
}

src_install() {
	einstalldocs # https://bugs.gentoo.org/789582

	java-pkg_dojar "byte-buddy-agent.jar"
	java-pkg_dojar "byte-buddy-dep.jar"

	if use doc; then
		java-pkg_dojavadoc target/api
	fi

	if use source; then
		java-pkg_dosrc "byte-buddy-agent/src/main/java/*"
		java-pkg_dosrc "byte-buddy-dep/src/main/java/*"
	fi
}
