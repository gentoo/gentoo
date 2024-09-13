# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.zeromq:jeromq:0.6.0"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Pure Java implementation of libzmq"
HOMEPAGE="https://github.com/zeromq/jeromq"
SRC_URI="https://github.com/zeromq/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

PROPERTIES="test_network"
RESTRICT="test"

DEPEND="
	>=dev-java/jnacl-1.0-r1:0
	>=virtual/jdk-11:*
"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( AUTHORS {CHANGELOG,CONTRIBUTING,README}.md )

JAVA_CLASSPATH_EXTRA="jnacl"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"

src_compile() {
	JAVA_JAR_FILENAME="org.zeromq.${PN}.jar"
	java-pkg-simple_src_compile	# creates a legacy jar file without module-info

	# maven does it with jnacl not providing module-info
	# need to figure out how jdeps could do so - we simply add one to jnacl
	jdeps \
		--module-path "$(java-pkg_getjars jnacl)" \
		--add-modules com.neilalexander.jnacl \
		--generate-module-info \
		src/main/java \
		--multi-release 9 \
		"${JAVA_JAR_FILENAME}" || die

	JAVA_JAR_FILENAME="${PN}.jar"
	java-pkg-simple_src_compile	# creates the final jar file including module-info
}
