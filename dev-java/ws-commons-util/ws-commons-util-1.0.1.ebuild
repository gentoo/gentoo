# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="1"
JAVA_PKG_IUSE="source test"
inherit java-pkg-2

DESCRIPTION="Utility classes that allow high performance XML processing based on SAX"
HOMEPAGE="http://ws.apache.org/commons/util/"
SRC_URI="mirror://apache/ws/commons/util/sources/${P}-src.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=">=virtual/jdk-1.4
	test? ( dev-java/junit:0 )"

RDEPEND=">=virtual/jre-1.4"

src_compile() {
	mkdir -p bin || die
	ejavac -d bin `find src/main -name "*.java" || die`
	`java-config -j` cvf "${PN}.jar" -C bin . || die
}

src_install() {
	java-pkg_dojar "${PN}.jar"
	use source && java-pkg_dosrc src/main/java/*
}

src_test() {
	local class files=`find src/test -name "*.java" || die`
	ejavac -cp bin:`java-pkg_getjars junit` -d bin ${files}

	for class in ${files} ; do
		class=${class#src/test/java/}
		class=${class%.java}
		ejunit -cp bin ${class//\//.}
	done
}
