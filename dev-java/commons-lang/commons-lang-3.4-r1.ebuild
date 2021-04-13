# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri http://distfiles.gentoo.org/distfiles/93/commons-lang3-3.4-src.tar.gz --slot 3.4 --keywords "~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris" --ebuild commons-lang-3.4-r1.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.apache.commons:commons-lang3:3.4"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Commons components to manipulate core java classes"
HOMEPAGE="http://commons.apache.org/proper/commons-lang/"
SRC_URI="mirror://apache/commons/lang/source/${PN}3-${PV}-src.tar.gz -> ${P}-sources.tar.gz"
LICENSE="Apache-2.0"
SLOT="3.4"
KEYWORDS="~amd64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris"

# Compile dependencies
# POM: pom.xml
# test? commons-io:commons-io:2.4 -> !!!groupId-not-found!!!
# test? junit:junit:4.12 -> >=dev-java/junit-4.12:4
# test? org.easymock:easymock:3.3.1 -> >=dev-java/easymock-3.3.1:3.2
# test? org.hamcrest:hamcrest-all:1.3 -> !!!artifactId-not-found!!!

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		dev-java/commons-io:1
		dev-java/easymock:3.2
		dev-java/hamcrest-library:1.3
		dev-java/junit:4
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
"

PATCHES=(
	"${FILESDIR}/${P}-disable-some-tests.patch"
)

S="${WORKDIR}/${PN}3-${PV}-src"

JAVA_ENCODING="ISO-8859-1"

JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS=(
	"src/main/resources"
)

JAVA_TEST_GENTOO_CLASSPATH="commons-io-1,easymock-3.2,hamcrest-library-1.3,junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_RESOURCE_DIRS=(
	"src/test/resources"
)

src_prepare() {
	default
	java-utils-2_src_prepare
}

src_test() {
	LC_ALL=C java-pkg-simple_src_test
}
