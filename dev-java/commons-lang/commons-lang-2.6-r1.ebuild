# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Commons components to manipulate core java classes"
HOMEPAGE="http://commons.apache.org/lang/"
SRC_URI="mirror://apache/commons/lang/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="amd64 ~arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris"
SLOT="2.1"
IUSE=""

DEPEND=">=virtual/jdk-1.4
	test? (
		dev-java/ant-junit:0
	)"

RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${P}-src"

JAVA_ANT_ENCODING="ISO-8859-1"

src_install() {
	java-pkg_newjar "target/${P}.jar" "${PN}.jar"
	dodoc RELEASE-NOTES.txt NOTICE.txt
	dohtml *.html
	use doc && java-pkg_dojavadoc target/apidocs
	use source && java-pkg_dosrc src/main/java/*
}
