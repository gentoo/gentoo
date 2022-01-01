# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

MY_P="${PN}3-${PV}"

DESCRIPTION="Commons components to manipulate core java classes"
HOMEPAGE="http://commons.apache.org/lang/"
SRC_URI="mirror://apache/commons/lang/source/${MY_P}-src.tar.gz"

DEPEND=">=virtual/jdk-1.5
	test? ( dev-java/ant-junit:0 )"

RDEPEND=">=virtual/jre-1.5"

LICENSE="Apache-2.0"
SLOT="3.1"
KEYWORDS="amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris"

S="${WORKDIR}/${MY_P}-src"

JAVA_ANT_ENCODING="ISO-8859-1"

src_install() {
	java-pkg_newjar target/${MY_P}.jar ${PN}.jar

	dodoc RELEASE-NOTES.txt NOTICE.txt

	use doc && java-pkg_dojavadoc target/apidocs
	use source && java-pkg_dosrc src/main/java/*
}
