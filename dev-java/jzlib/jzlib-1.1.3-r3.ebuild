# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="examples source test"
MAVEN_ID="com.jcraft:jzlib:1.1.3"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JZlib is a re-implementation of zlib in pure Java"
HOMEPAGE="http://www.jcraft.com/jzlib/"
SRC_URI="https://github.com/ymnk/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 ~x64-macos ~x64-solaris"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"
# Restrict test due to missing keywords for scala
RESTRICT="test"

DOCS=( README ChangeLog )

JAVA_SRC_DIR="src/main/java"

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
	use examples && java-pkg_doexamples example
}
