# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/jnr/jnr-ffi/archive/refs/tags/jnr-ffi-2.2.4.tar.gz --slot 2 --keywords "~amd64 ~arm64 ~x86" --ebuild jnr-ffi-2.2.4.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.github.jnr:jnr-ffi:2.2.4"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A library for invoking native functions from java"
HOMEPAGE="https://github.com/jnr/jnr-ffi"
SRC_URI="https://github.com/jnr/${PN}/archive/refs/tags/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~arm64 ~x86"

# Common dependencies
# POM: pom.xml
# com.github.jnr:jffi:1.3.3 -> !!!artifactId-not-found!!!
# com.github.jnr:jnr-a64asm:1.0.0 -> >=dev-java/jnr-a64asm-1.0.0:2
# com.github.jnr:jnr-x86asm:1.0.2 -> >=dev-java/jnr-x86asm-1.0.2:1.0
# org.ow2.asm:asm:9.1 -> >=dev-java/asm-9.1:9
# org.ow2.asm:asm-analysis:9.1 -> >=dev-java/asm-analysis-9.1:9
# org.ow2.asm:asm-commons:9.1 -> >=dev-java/asm-commons-9.1:9
# org.ow2.asm:asm-tree:9.1 -> >=dev-java/asm-tree-9.1:9
# org.ow2.asm:asm-util:9.1 -> >=dev-java/asm-util-9.1:9

CDEPEND="
	dev-java/asm:9
	dev-java/asm-analysis:9
	dev-java/asm-commons:9
	dev-java/asm-tree:9
	dev-java/asm-util:9
	dev-java/jffi:1.2
	dev-java/jnr-a64asm:2
	dev-java/jnr-x86asm:1.0
"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.8:*
"

# Runtime dependencies
# POM: pom.xml
# com.github.jnr:jffi:1.3.3 -> !!!artifactId-not-found!!!

RDEPEND="${CDEPEND}
	dev-java/jffi:1.2
	>=virtual/jre-1.8:*
"

S="${WORKDIR}/${PN}-${P}"

JAVA_GENTOO_CLASSPATH="asm-9,asm-analysis-9,asm-commons-9,asm-tree-9,asm-util-9,jffi-1.2,jnr-a64asm-2,jnr-x86asm-1.0"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	default

#<tasks>
#	<exec failonerror="true" dir="/var/tmp/portage/dev-java/jnr-ffi-2.2.4/work/jnr-ffi-jnr-ffi-2.2.4" executable="make">
#		<arg line="-f libtest/GNUmakefile"/>
#		<arg line="BUILD_DIR=/var/tmp/portage/dev-java/jnr-ffi-2.2.4/work/jnr-ffi-jnr-ffi-2.2.4/target"/>
#		<arg line="CPU=amd64"/>
#	</exec>${tasks}</tasks>

	emake -f libtest/GNUmakefile \
	BUILD_DIR=target \
	CPU=amd64 || die
}
