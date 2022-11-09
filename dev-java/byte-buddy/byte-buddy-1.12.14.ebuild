# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/raphw/byte-buddy/archive/byte-buddy-1.12.14.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild byte-buddy-1.12.14.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="net.bytebuddy:byte-buddy-agent:1.12.14"
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

RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/${PN}-${P}"

JAVA_CLASSPATH_EXTRA="
	asm-9
	findbugs-annotations
	jsr305
	jna-4
"

src_prepare() {
	default
	# https://github.com/raphw/byte-buddy/blob/byte-buddy-1.12.14/byte-buddy-agent/pom.xml#L132-L166
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

	# adjustment for recent mockito versions
	sed \
		-e 's:verifyZeroInteractions:verifyNoInteractions:g' \
		-i byte-buddy-dep/src/test/java/net/bytebuddy/*.java \
		-i byte-buddy-dep/src/test/java/net/bytebuddy/*/*Test.java \
		-i byte-buddy-dep/src/test/java/net/bytebuddy/*/*/*Test.java \
		-i byte-buddy-dep/src/test/java/net/bytebuddy/*/*/*/*Test.java \
		-i byte-buddy-dep/src/test/java/net/bytebuddy/*/*/*/*/*Test.java \
		|| die

	# instead of shading byte-buddy-dep we move it into byte-buddy.
	mv byte-buddy{-dep,}/src/main/java || die "cannot move sources"
	mv byte-buddy{-dep,}/src/test || die "cannot move tests"

	# https://github.com/raphw/byte-buddy/blob/byte-buddy-1.12.14/byte-buddy/pom.xml#L159-L195
	cat > byte-buddy/src/main/java/module-info.java <<-EOF
		module net.bytebuddy {
			requires static java.instrument;
			requires static java.management;
			requires static jdk.unsupported;
			requires static net.bytebuddy.agent;
			requires static com.sun.jna;
			requires static com.sun.jna.platform;
			requires java.base;
			exports net.bytebuddy;
			exports net.bytebuddy.agent.builder;
			exports net.bytebuddy.asm;
			exports net.bytebuddy.build;
			exports net.bytebuddy.description;
			exports net.bytebuddy.description.annotation;
			exports net.bytebuddy.description.enumeration;
			exports net.bytebuddy.description.field;
			exports net.bytebuddy.description.method;
			exports net.bytebuddy.description.modifier;
			exports net.bytebuddy.description.type;
			exports net.bytebuddy.dynamic;
			exports net.bytebuddy.dynamic.loading;
			exports net.bytebuddy.dynamic.scaffold;
			exports net.bytebuddy.dynamic.scaffold.inline;
			exports net.bytebuddy.dynamic.scaffold.subclass;
			exports net.bytebuddy.implementation;
			exports net.bytebuddy.implementation.attribute;
			exports net.bytebuddy.implementation.auxiliary;
			exports net.bytebuddy.implementation.bind;
			exports net.bytebuddy.implementation.bind.annotation;
			exports net.bytebuddy.implementation.bytecode;
			exports net.bytebuddy.implementation.bytecode.assign;
			exports net.bytebuddy.implementation.bytecode.assign.primitive;
			exports net.bytebuddy.implementation.bytecode.assign.reference;
			exports net.bytebuddy.implementation.bytecode.collection;
			exports net.bytebuddy.implementation.bytecode.constant;
			exports net.bytebuddy.implementation.bytecode.member;
			exports net.bytebuddy.matcher;
			exports net.bytebuddy.pool;
			exports net.bytebuddy.utility;
			exports net.bytebuddy.utility.nullability;
			exports net.bytebuddy.utility.privilege;
			exports net.bytebuddy.utility.visitor;
		}
	EOF
	# We don't bundle, hence cannot export them
			# exports net.bytebuddy.jar.asm;
			# exports net.bytebuddy.jar.asm.signature;
			# exports net.bytebuddy.jar.asm.commons;
}

src_compile() {
	einfo "Compiling byte-buddy-agent.jar"
	JAVA_SRC_DIR="byte-buddy-agent/src/main/java"
	JAVA_RESOURCE_DIRS="byte-buddy-agent/src/main/resources"
	JAVA_JAR_FILENAME="byte-buddy-agent.jar"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":byte-buddy-agent.jar"
	rm -r target || die

	einfo "Compiling byte-buddy.jar"
	JAVA_SRC_DIR="byte-buddy/src/main/java"
	JAVA_RESOURCE_DIRS=()
	JAVA_JAR_FILENAME="byte-buddy.jar"
	JAVA_MAIN_CLASS="net.bytebuddy.build.Plugin\$Engine\$Default"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":byte-buddy.jar"
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

	einfo "Testing byte-buddy"
	JAVA_TEST_SRC_DIR="byte-buddy/src/test/java"
	JAVA_TEST_RESOURCE_DIRS=(
		byte-buddy/src/test/resources
		byte-buddy/src/test/precompiled*
	)

	# what "mvn test" does with java 17 is:
	# Tests run: 10022, Failures: 0, Errors: 0, Skipped: 0
	JAVA_TEST_EXCLUDES+=(
		net.bytebuddy.pool.TypePoolDefaultMethodDescriptionTest	# 39 tests
		net.bytebuddy.build.CachedReturnPluginTest	# 44 tests
		net.bytebuddy.build.CachedReturnPluginOtherTest	# 4 tests
	)
	java-pkg-simple_src_test
}

src_install() {
	java-pkg_dojar "byte-buddy-agent.jar"
	java-pkg_dojar "byte-buddy.jar"

	if use doc; then
		java-pkg_dojavadoc target/api
	fi

	if use source; then
		java-pkg_dosrc "byte-buddy-agent/src/main/java/*"
		java-pkg_dosrc "byte-buddy/src/main/java/*"
	fi
}
