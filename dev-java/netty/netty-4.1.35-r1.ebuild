# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom common/pom.xml --download-uri https://codeload.github.com/netty/netty/tar.gz/netty-4.1.35.Final --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild netty-4.1.35.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="io.netty:netty:4.1.35.Final"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Async event-driven framework for high performance network applications"
HOMEPAGE="https://netty.io/"
SRC_URI="https://github.com/netty/netty/archive/refs/tags/netty-${PV}.Final.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc64 x86"

# We do not build the full range of modules provided by netty but only what
# was available before in netty-common, netty-buffer and netty-transport.
# Further modules might be added to the array.
NETTY_MODULES=(
	"common"
	"resolver"
	"buffer"
	"transport"
)

# Common dependencies
# POM: common/pom.xml
# commons-logging:commons-logging:1.2 -> >=dev-java/commons-logging-1.2:0
# log4j:log4j:1.2.17 -> >=dev-java/log4j-1.2.17:0
# org.apache.logging.log4j:log4j-api:2.6.2 -> >=dev-java/log4j-api-2.17.1:2
# org.jctools:jctools-core:2.1.1 -> !!!suitable-mavenVersion-not-found!!!
# org.slf4j:slf4j-api:1.7.21 -> >=dev-java/slf4j-api-1.7.32:0

# "Failed to load class org.slf4j.impl.StaticLoggerBinder"
# Using slf4j-simple instead of slf4j-api solves it.
# https://www.slf4j.org/codes.html
CP_DEPEND="
	dev-java/commons-logging:0
	dev-java/jctools-core:3
	dev-java/log4j-12-api:2
	dev-java/slf4j-simple:0
"

# Compile dependencies
# POM: common/pom.xml
# test? ch.qos.logback:logback-classic:1.1.7 -> !!!groupId-not-found!!!
# test? io.netty:netty-build:25 -> !!!artifactId-not-found!!!
# test? io.netty:netty-dev-tools:4.1.35.Final -> !!!artifactId-not-found!!!
# test? junit:junit:4.12 -> >=dev-java/junit-4.13.2:4
# test? org.apache.logging.log4j:log4j-core:2.6.2 -> >=dev-java/log4j-core-2.17.1:2
# test? org.hamcrest:hamcrest-library:1.3 -> >=dev-java/hamcrest-library-1.3:1.3
# test? org.javassist:javassist:3.20.0-GA -> !!!groupId-not-found!!!
# test? org.mockito:mockito-core:2.18.3 -> >=dev-java/mockito-4.4.0:4

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
	test? (
		dev-java/javassist:3
		dev-java/hamcrest-library:1.3
		dev-java/logback-classic:0
		dev-java/log4j-core:2
		dev-java/mockito:4
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

S="${WORKDIR}/netty-netty-${PV}.Final"

JAVA_TEST_GENTOO_CLASSPATH="hamcrest-library-1.3,javassist-3,junit-4,logback-classic,log4j-core-2,mockito-4"

# There were 12 failures:
# 1) testCompositeDirectBuffer(io.netty.buffer.ByteBufAllocatorTest)
# java.lang.InstantiationException
#         at java.base/jdk.internal.reflect.InstantiationExceptionConstructorAccessorImpl.newInstance(InstantiationExceptionConstructorAccessorImpl.java:48)
#
# FAILURES!!!
# Tests run: 10015,  Failures: 12

# There was 1 failure:
# 1) initializationError(io.netty.channel.BaseChannelTest)
# org.junit.runners.model.InvalidTestClassError: Invalid test class 'io.netty.channel.BaseChannelTest':
#   1. The class io.netty.channel.BaseChannelTest is not public.
#   2. Test class should have exactly one public constructor
#   3. No runnable methods
#
# FAILURES!!!
# Tests run: 10277,  Failures: 1

JAVA_TEST_EXCLUDES=(
	"io.netty.buffer.ByteBufAllocatorTest"
	"io.netty.channel.BaseChannelTest"
)

src_prepare() {
	default

	sed \
		-e 's:verifyZeroInteractions:verifyNoInteractions:' \
		-i buffer/src/test/java/io/netty/buffer/UnpooledTest.java \
		-i transport/src/test/java/io/netty/channel/CompleteChannelFutureTest.java || die

	# transport/src/test/java/io/netty/channel/PendingWriteQueueTest.java:262: error: reference to assertEquals is ambiguous
	#         assertEquals(1L, channel.readOutbound());
	#         ^
	#   both method assertEquals(long,long) in Assert and method assertEquals(Object,Object) in Assert match
	rm transport/src/test/java/io/netty/channel/PendingWriteQueueTest.java || die
}

src_compile() {
	local module
	# We loop over the modules list and compile the jar files.
	for module in "${NETTY_MODULES[@]}"; do
		JAVA_SRC_DIR=()
		JAVA_RESOURCE_DIRS=()
		JAVA_MAIN_CLASS=""

		JAVA_SRC_DIR=(
			"$module/src/main/java"
			"$module/src/module"
		)

		# Not all of the modules have resources.
		if [[ -d $module/src/main/resources ]]; then \
			JAVA_RESOURCE_DIRS="$module/src/main/resources"
		fi

		JAVA_JAR_FILENAME="$module.jar"

		einfo "Compiling netty-${module}"
		java-pkg-simple_src_compile

		JAVA_GENTOO_CLASSPATH_EXTRA+=":$module.jar"

		rm -r target || die

	done

	if use doc; then
		JAVA_SRC_DIR=()
		JAVA_JAR_FILENAME="ignoreme.jar"

		for module in "${NETTY_MODULES[@]}" ; do
			# Some modules don't have source code
			if [[ -d $module/src/main/java/io ]]; then \
				JAVA_SRC_DIR+=( "$module/src/main/java" )
			fi

		done

		java-pkg-simple_src_compile
	fi
}

src_test() {
	local module
	for module in "${NETTY_MODULES[@]}"; do
		JAVA_TEST_SRC_DIR="$module/src/test/java"
		JAVA_TEST_RESOURCE_DIRS=()

		# Not all of the modules have test resources.
		if [[ -d $module/src/test/resources ]]; then \
			JAVA_TEST_RESOURCE_DIRS="$module/src/test/resources"
		fi

		einfo "Testing netty-${module}"
		java-pkg-simple_src_test
	done
}

src_install() {
	einstalldocs # https://bugs.gentoo.org/789582

	local module
	for module in "${NETTY_MODULES[@]}"; do
		JAVA_MAIN_CLASS=$( sed -n 's:.*<mainClass>\(.*\)</mainClass>:\1:p' $module/pom.xml )
		java-pkg_dojar $module.jar

		# Some modules don't have source code
		if [[ -d $module/src/main/java/org ]]; then
			if use source; then
				java-pkg_dosrc "$module/src/main/java/*"
			fi
		fi
	done

	if use doc; then
		java-pkg_dojavadoc target/api
	fi
}
