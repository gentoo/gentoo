# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JRobin is a 100% pure Java alternative to RRDTool"
HOMEPAGE="http://www.jrobin.org/"
SRC_URI="https://github.com/OpenNMS/${PN}/archive/${P}-1.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6
	test? (	dev-java/asm:4
		>=dev-java/cglib-3.1:3
		dev-java/easymock:3.2
		dev-java/junit:4
		dev-java/objenesis:0 )"

S="${WORKDIR}/${PN}-${P}-1/src"
JAVA_SRC_DIR="main/java"

java_prepare() {
	find "${WORKDIR}" -name "*.jar" -delete || die

	# The tests need the resources in this directory for some reason.
	mkdir -p test/java/target/classes || die
	cd test/java/target/classes || die
	ln -snf ../../../../main/resources/* . || die
}

src_compile() {
	java-pkg-simple_src_compile
	jar uf "${PN}.jar" -C main/resources . || die
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dolauncher "${PN}-rrdtool" --main org.jrobin.cmd.RrdCommander
}

src_test() {
	cd test/java || die

	local CP=".:${S}/${PN}.jar:$(java-pkg_getjars asm-4,cglib-3,easymock-3.2,junit-4,objenesis)"
	local TESTS=$(find * -name "*Test.java")
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -cp "${CP}" -d . $(find * -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}

pkg_postinst() {
	elog "The rrdtool executable has been installed as ${PN}-rrdtool to"
	elog "avoid conflicting with net-analyzer/rrdtool."
}
