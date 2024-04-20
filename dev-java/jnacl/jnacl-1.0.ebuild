# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/neilalexander/jnacl/archive/refs/tags/v1.0.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild jnacl-1.0.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.neilalexander:jnacl:1.0"
# JAVA_TESTING_FRAMEWORKS="testng"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Pure Java implementation of NaCl: Networking and Cryptography library"
HOMEPAGE="https://github.com/neilalexander/jnacl"
SRC_URI="https://github.com/neilalexander/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

# We don't have fest-assert
RESTRICT="test"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# Compile dependencies
# POM: pom.xml
# test? org.easytesting:fest-assert:1.4 -> !!!groupId-not-found!!!
# test? org.testng:testng:6.13.1 -> !!!groupId-not-found!!!

DEPEND=">=virtual/jdk-1.8:*"
#	test? (
#		!!!groupId-not-found!!!
#	)
#"

RDEPEND=">=virtual/jre-1.8:*"

DOCS=( LICENSE README.md )

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src/main/java"

# JAVA_TEST_GENTOO_CLASSPATH="!!!groupId-not-found!!!,!!!groupId-not-found!!!"
# JAVA_TEST_SRC_DIR="src/test/java"

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
