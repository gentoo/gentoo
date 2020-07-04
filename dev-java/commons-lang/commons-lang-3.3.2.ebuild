# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

MY_P="${PN}3-${PV}"

DESCRIPTION="Commons components to manipulate core java classes"
HOMEPAGE="http://commons.apache.org/lang/"
SRC_URI="mirror://apache/commons/lang/source/${MY_P}-src.tar.gz"

DEPEND=">=virtual/jdk-1.6
	!ppc? (
		!ppc64? (
			test? (
				dev-java/ant-junit4
				dev-java/commons-io:1
				dev-java/easymock:3.2
			)
		)
	)"

RDEPEND=">=virtual/jre-1.6"

LICENSE="Apache-2.0"
SLOT="3.3"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris"
RESTRICT+=" ppc? ( test ) ppc64? ( test )"

S="${WORKDIR}/${MY_P}-src"

JAVA_ANT_ENCODING="ISO-8859-1"
EANT_TEST_GENTOO_CLASSPATH="easymock-3.2,commons-io-1,junit-4"
JAVA_ANT_REWRITE_CLASSPATH="yes"

src_install() {
	java-pkg_newjar target/${MY_P}.jar ${PN}.jar

	dodoc RELEASE-NOTES.txt NOTICE.txt

	use doc && java-pkg_dojavadoc target/apidocs
	use source && java-pkg_dosrc src/main/java/*
}

src_test() {
	LC_ALL=C java-pkg-2_src_test
}
