# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="netty"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Async event-driven framework for high performance network applications"
HOMEPAGE="https://netty.io/"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/${MY_P}.Final.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND="~dev-java/${MY_PN}-buffer-${PV}:0
	~dev-java/${MY_PN}-common-${PV}:0"

RDEPEND=">=virtual/jre-1.7
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.7
	${CDEPEND}
	test? (
		dev-java/easymock:3.2
		dev-java/hamcrest-core:1.3
		dev-java/hamcrest-library:1.3
		dev-java/junit:4
		dev-java/mockito:0
		dev-java/objenesis:0
	)"

S="${WORKDIR}/${MY_PN}-${MY_P}.Final/${PN/${MY_PN}-}"
JAVA_SRC_DIR="src/main/java"
JAVA_GENTOO_CLASSPATH="${MY_PN}-buffer,${MY_PN}-common"

java_prepare() {
	# Need to package "classic" component of logback.
	rm -v src/test/java/io/netty/channel/SingleThreadEventLoopTest.java || die
}

src_test() {
	ewarn "If the hostname does not resolve to this system then these tests will"
	ewarn "fail. It is currently set to: $(uname -n)"

	cd src/test/java || die

	# --with-dependencies breaks while mockito needs hamcrest-core:0.
	local CP=".:${S}/${PN}.jar:$(java-pkg_getjars ${JAVA_GENTOO_CLASSPATH},easymock-3.2,hamcrest-core-1.3,hamcrest-library-1.3,junit-4,mockito,objenesis)"
	local TESTS=$(find * -name "*Test.java" ! -name "Abstract*" ! -name "Base*")
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -cp "${CP}" -d . $(find * -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
