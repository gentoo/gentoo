# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/raphw/byte-buddy/archive/byte-buddy-1.12.13.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild byte-buddy-1.12.13.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="net.bytebuddy:byte-buddy-agent:1.12.13"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Offers convenience for attaching an agent to the local or a remote VM"
HOMEPAGE="https://bytebuddy.net"
SRC_URI="https://github.com/raphw/${PN}/archive/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND="
	>=virtual/jdk-11:*
	dev-java/asm:9
	dev-java/findbugs-annotations:0
	dev-java/jna:4
	dev-java/jsr305:0
	test? (
		dev-java/mockito:4
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
"

S="${WORKDIR}/${PN}-${P}"

JAVA_CLASSPATH_EXTRA="
	asm-9
	findbugs-annotations
	jsr305
	jna-4
"

src_prepare() {
	default
	# https://github.com/raphw/byte-buddy/blob/byte-buddy-1.12.12/byte-buddy-agent/pom.xml#L132-L165
	cat > byte-buddy-agent/src/main/java/module-info.java <<-EOF
		module net.bytebuddy.agent {
			requires java.instrument;
			requires static jdk.attach;
			requires static com.sun.jna;
			requires static com.sun.jna.platform;
			requires java.base;
			exports net.bytebuddy.agent;
			exports net.bytebuddy.agent.utility.nullability;
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
	JAVA_RESOURCE_DIRS=()
	JAVA_JAR_FILENAME="byte-buddy-dep.jar"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":byte-buddy-dep.jar"
	rm -r target || die

	if use doc; then
		einfo "Compiling javadocs"
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

	# einfo "Setting -Djava.library.path"
	# This would work only after manually adding libjnidispatch.so to /usr/share/jna-4/lib/jna.jar,
	# done with ( jar -uf /usr/share/jna-4/lib/jna.jar -C . com/sun/jna/linux-x86-64/libjnidispatch )
#	JAVA_TEST_EXTRA_ARGS=( -Djava.library.path+="$(java-config -i jna-4)" com.sun.jna.Native )
	# Otherwise fails with:
	# Exception in thread "main" java.lang.UnsatisfiedLinkError: Native library (com/sun/jna/linux-x86-64/libjnidispatch.so) not found in resource path

	einfo "Testing byte-buddy-agent"
	JAVA_TEST_SRC_DIR="byte-buddy-agent/src/test/java"
	# Native library (com/sun/jna/linux-x86-64/libjnidispatch.so) not found in resource path
	JAVA_TEST_EXCLUDES=(
		net.bytebuddy.agent.VirtualMachineAttachmentTest
	)
	java-pkg-simple_src_test

	einfo "Testing byte-buddy-dep"
	JAVA_TEST_SRC_DIR="byte-buddy-dep/src/test/java"
	JAVA_TEST_RESOURCE_DIRS=(
		byte-buddy-dep/src/test/resources
		byte-buddy-dep/src/test/precompiled*
	)

	# what "mvn test" does with java 17 is:
	# Tests run: 9855, Failures: 0, Errors: 0, Skipped: 0
	JAVA_TEST_EXCLUDES+=(
		net.bytebuddy.pool.TypePoolDefaultMethodDescriptionTest	# 39 tests
		# v1.12.13
		net.bytebuddy.build.CachedReturnPluginTest	# 44 tests
		net.bytebuddy.build.CachedReturnPluginOtherTest	# 4 tests
	)
	java-pkg-simple_src_test
}

src_install() {
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
