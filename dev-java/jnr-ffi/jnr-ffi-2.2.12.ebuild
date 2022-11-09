# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/jnr/jnr-ffi/archive/jnr-ffi-2.2.12.tar.gz --slot 2 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild jnr-ffi-2.2.12.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.github.jnr:jnr-ffi:2.2.12"
# We don't have junit-jupiter yet
# JAVA_TESTING_FRAMEWORKS="junit-jupiter"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A library for invoking native functions from java"
HOMEPAGE="https://github.com/jnr/jnr-ffi"
SRC_URI="https://github.com/jnr/${PN}/archive/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

CP_DEPEND="
	dev-java/asm:9
	>=dev-java/jffi-1.3.8:1.3
	dev-java/jnr-a64asm:2
	dev-java/jnr-x86asm:1.0
"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

S="${WORKDIR}/${PN}-${P}"

JAVA_SRC_DIR="src/main/java"

# JAVA_TEST_GENTOO_CLASSPATH="!!!groupId-not-found!!!"
# JAVA_TEST_SRC_DIR="src/test/java"

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
