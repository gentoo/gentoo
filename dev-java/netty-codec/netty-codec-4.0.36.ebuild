# Copyright 1999-2020 Gentoo Authors
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
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND="~dev-java/${MY_PN}-buffer-${PV}:0
	~dev-java/${MY_PN}-common-${PV}:0
	~dev-java/${MY_PN}-transport-${PV}:0
	dev-java/jboss-marshalling:0
	dev-java/jzlib:1.1.3
	dev-java/protobuf-java:0"

RDEPEND=">=virtual/jre-1.7
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.7
	${CDEPEND}
	test? (
		dev-java/hamcrest-core:1.3
		dev-java/hamcrest-library:1.3
		dev-java/jboss-marshalling-river:0
		dev-java/jboss-marshalling-serial:0
		dev-java/junit:4
	)"

S="${WORKDIR}/${MY_PN}-${MY_P}.Final/${PN/${MY_PN}-}"
JAVA_SRC_DIR="src/main/java"
JAVA_GENTOO_CLASSPATH="${MY_PN}-buffer,${MY_PN}-common,${MY_PN}-transport,jboss-marshalling,jzlib-1.1.3,protobuf-java"

src_test() {
	cd src/test/java || die

	local CP=".:${S}/${PN}.jar:$(java-pkg_getjars --with-dependencies ${JAVA_GENTOO_CLASSPATH},hamcrest-core-1.3,hamcrest-library-1.3,jboss-marshalling-river,jboss-marshalling-serial,junit-4)"
	local TESTS=$(find * -name "*Test.java" ! -name "Abstract*" ! -name "ZlibTest*")
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -cp "${CP}" -d . $(find * -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
