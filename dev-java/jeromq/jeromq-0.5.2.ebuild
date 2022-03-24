# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/zeromq/jeromq/archive/refs/tags/v0.5.2.tar.gz --slot 0 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild jeromq-0.5.2.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.zeromq:jeromq:0.5.2"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Pure Java implementation of libzmq"
HOMEPAGE="https://github.com/zeromq/jeromq"
SRC_URI="https://github.com/zeromq/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

PROPERTIES="test_network"
RESTRICT="test"

# Common dependencies
# POM: pom.xml
# com.neilalexander:jnacl:1.0.0 -> >=dev-java/jnacl-1.0:0

CP_DEPEND="dev-java/jnacl:0"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( AUTHORS LICENSE {CHANGELOG,CONTRIBUTING,README}.md )

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
