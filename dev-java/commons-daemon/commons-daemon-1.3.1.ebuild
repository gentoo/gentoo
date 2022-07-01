# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri mirror://apache/commons/daemon/source/commons-daemon-1.2.4-src.tar.gz --slot 0 --keywords "~amd64 ~ppc64 ~x86" --ebuild commons-daemon-1.2.4.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="commons-daemon:commons-daemon:1.3.1"
# JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple toolchain-funcs

DESCRIPTION="Tools to allow Java programs to run as UNIX daemons"
HOMEPAGE="https://commons.apache.org/proper/commons-daemon/"
SRC_URI="mirror://apache/commons/daemon/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ppc64 x86"

DEPEND="
	>=virtual/jdk-1.8:*
"

RDEPEND="
	>=virtual/jre-1.8:*
"

PATCHES=( "${FILESDIR}/commons-daemon-1.3.1-Make.patch" )
DOCS=( {CONTRIBUTING,README}.md {HOWTO-RELEASE,NOTICE,RELEASE-NOTES}.txt )
HTML_DOCS=( PROPOSAL.html )

S="${WORKDIR}/${P}-src"

JAVA_ENCODING="iso-8859-1"

JAVA_SRC_DIR="src/main/java"

# There is only org/apache/commons/daemon/SimpleDaemon.java
# which is not even run upstream ( mvn test ).
# JAVA_TEST_GENTOO_CLASSPATH="junit-4"
# JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	default
	java-pkg-2_src_prepare
}

src_compile() {
	java-pkg-simple_src_compile

	pushd src/native/unix || die
		./configure
		emake AR="$(tc-getAR)"
	popd
}

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install

	dobin src/native/unix/jsvc
}
