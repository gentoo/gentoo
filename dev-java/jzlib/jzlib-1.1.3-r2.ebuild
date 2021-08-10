# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="examples source test"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JZlib is a re-implementation of zlib in pure Java"
HOMEPAGE="http://www.jcraft.com/jzlib/"
SRC_URI="https://github.com/ymnk/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	>=virtual/jre-1.8:*"
DEPEND="
	>=virtual/jdk-1.8:*"
#	test? (
#		dev-lang/scala
#		dev-java/junit:4 )"
# Restrict test due to missing keywords for scala
RESTRICT="test"

S="${WORKDIR}/${P}"
JAVA_SRC_DIR="src/main/java"

src_prepare() {
	default
	rm pom.xml || die
}

src_test() {
	local CP TESTS
	CP="${PN}.jar:$(java-pkg_getjars --with-dependencies scala,junit-4)" || die
	TESTS=$(find src/test/scala -name '*Test.scala' -printf com.jcraft.jzlib. -exec basename {} .scala \;) || die

	mkdir -p target/test || die
	find src/test/scala -name '*.scala' -exec scalac -classpath "${CP}" -d target/test {} + || die
	ejunit4 -classpath "target/test:${CP}" ${TESTS}
}

src_install() {
	java-pkg-simple_src_install
	dodoc README ChangeLog
	use examples && java-pkg_doexamples example
}
