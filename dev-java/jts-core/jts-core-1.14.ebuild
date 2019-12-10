# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# The project recently switched to git. There are no tags yet.
GIT_REF="f67d35c1da06922c8165f66a919490ee94a04649"

MY_PN="jts"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JTS Topology Suite for Java"
HOMEPAGE="https://tsusiatsoftware.net/jts/main.html"
SRC_URI="https://github.com/dr-jts/jts/archive/${GIT_REF}.tar.gz -> ${MY_PN}-${PV}.tar.gz"
LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND=">=virtual/jdk-1.7
	app-arch/unzip
	test? ( dev-java/junit:4 )"

RDEPEND=">=virtual/jre-1.7"

S="${WORKDIR}/${MY_PN}-${GIT_REF}/${MY_PN}"
JAVA_SRC_DIR="java/src"

java_prepare() {
	java-pkg_clean

	# Use text-based test runner.
	sed -i "s/swingui/textui/g" java/test/test/jts/junit/SimpleTest.java || die
}

src_test() {
	cd java/test || die
	local CP=".:${S}/${PN}.jar:$(java-pkg_getjars junit-4)"
	ejavac -cp "${CP}" -d . $(find * -name "*.java")
	ejunit4 -classpath "${CP}" test.jts.junit.MasterTester
}
