# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_PROVIDES="net.bytebuddy:byte-buddy-agent:${PV} net.bytebuddy:byte-buddy:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Offers convenience for attaching an agent to the local or a remote VM"
HOMEPAGE="https://bytebuddy.net"
SRC_URI="https://github.com/raphw/byte-buddy/archive/${P}.tar.gz"
S="${WORKDIR}/byte-buddy-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc64"

DEPEND="
	>=dev-java/asm-9.7.1:9
	dev-java/findbugs-annotations:0
	dev-java/jna:4
	dev-java/jsr305:0
	>=virtual/jdk-11:*
	test? (
		>=dev-java/mockito-2.28.2-r1:2
	)
"

RDEPEND=">=virtual/jre-1.8:*"

PATCHES=( "${FILESDIR}/byte-buddy-1.15.10-Skip-testIgnoreExistingField.patch" )

JAVA_CLASSPATH_EXTRA="
	asm-9
	findbugs-annotations
	jna-4
	jsr305
"
JAVADOC_CLASSPATH="${JAVA_CLASSPATH_EXTRA}"
JAVADOC_SRC_DIRS=(
	"byte-buddy-agent/src/main/java"
	"byte-buddy/src/main/java"
)

src_prepare() {
	default #780585
	java-pkg_clean ! -path "./byte-buddy-dep/src/test/*"	# Keep test-classes
	java-pkg-2_src_prepare
	# https://github.com/raphw/byte-buddy/blob/byte-buddy-1.12.20/byte-buddy-agent/pom.xml#L142-L176
	cat > byte-buddy-agent/src/main/java/module-info.java <<-EOF || die
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

	# instead of shading byte-buddy-dep we move it into byte-buddy.
	mv byte-buddy{-dep,}/src/main/java || die "cannot move sources"

	# https://github.com/raphw/byte-buddy/blob/byte-buddy-1.12.20/byte-buddy/pom.xml#L159-L195
	local exports="$( \
		sed -n '/<packages.list.external>/,/<\/packages.list.external/p' \
		byte-buddy/pom.xml \
		| sed -e 's:^:exports :' -e 's:,:;:' \
		| grep -v 'packages.list.external\|shade' | tr -s '[:space:]' \
		)" || die
	cat > byte-buddy/src/main/java/module-info.java <<-EOF || die
		module net.bytebuddy {
			requires static java.instrument;
			requires static java.management;
			requires static jdk.unsupported;
			requires static net.bytebuddy.agent;
			requires static com.sun.jna;
			requires static com.sun.jna.platform;
			requires java.base;
			${exports}
		}
	EOF
}

src_compile() {
	einfo "Compiling byte-buddy-agent.jar"
	JAVA_JAR_FILENAME="byte-buddy-agent.jar"
	JAVA_RESOURCE_DIRS="byte-buddy-agent/src/main/resources"
	JAVA_SRC_DIR="byte-buddy-agent/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":byte-buddy-agent.jar"
	rm -r target || die

	einfo "Compiling byte-buddy.jar"
	JAVA_JAR_FILENAME="byte-buddy.jar"
	JAVA_MAIN_CLASS="net.bytebuddy.build.Plugin\$Engine\$Default"
	JAVA_RESOURCE_DIRS=()
	JAVA_SRC_DIR="byte-buddy/src/main/java"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":byte-buddy.jar"
	rm -r target || die

	einfo "Building javadocs"
	rm byte-buddy{,-agent}/src/main/java/module-info.java || die
	use doc && ejavadoc
}

src_test() {
	# instead of shading byte-buddy-dep we move it into byte-buddy.
	mv byte-buddy{-dep,}/src/test || die "cannot move tests"

	JAVAC_ARGS="-g"
	JAVA_TEST_GENTOO_CLASSPATH="junit-4,mockito-2"

	einfo "Testing byte-buddy-agent"
	# https://github.com/raphw/byte-buddy/issues/1321#issuecomment-1252776459
	JAVA_TEST_EXTRA_ARGS=( -Dnet.bytebuddy.test.jnapath="${EPREFIX}/usr/$(get_libdir)/jna-4/" )
	JAVA_TEST_SRC_DIR="byte-buddy-agent/src/test/java"
	java-pkg-simple_src_test

	einfo "Testing byte-buddy"
	JAVA_TEST_RESOURCE_DIRS=( byte-buddy/src/test/{resources,precompiled*} )
	JAVA_TEST_SRC_DIR="byte-buddy/src/test/java"

	JAVA_TEST_EXCLUDES=(
		# all tests in this class fail, https://bugs.gentoo.org/863386
		net.bytebuddy.build.CachedReturnPluginTest
	)
	java-pkg-simple_src_test
}

src_install() {
	java-pkg_dojar "byte-buddy-agent.jar"
	java-pkg-simple_src_install

	if use source; then
		java-pkg_dosrc "byte-buddy-agent/src/main/java/*"
		java-pkg_dosrc "byte-buddy/src/main/java/*"
	fi
}
