# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A JSON StAX implementation"
HOMEPAGE="https://github.com/codehaus/jettison"
SRC_URI="https://github.com/codehaus/${PN}/archive/${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="test"

RDEPEND=">=virtual/jre-1.6"

DEPEND=">=virtual/jdk-1.6
	test? (
		dev-java/junit:4
		dev-java/wstx:3.2 )"

S="${WORKDIR}/${PN}-${P}"
JAVA_SRC_DIR="${S}/src/main/java"

src_test() {
	cd src/test/java || die
	local CP=".:${S}/${PN}.jar:$(java-pkg_getjars junit-4,wstx-3.2)"

	local TESTS=$(find * -name "*Test.java" ! -name "DOMTest.java")
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -classpath "${CP}" $(find -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
