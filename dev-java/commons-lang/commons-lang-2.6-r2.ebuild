# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="commons-lang:commons-lang:2.6"
JAVA_PKG_WANT_SOURCE="1.4"
JAVA_PKG_WANT_TARGET="1.4"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Commons components to manipulate core java classes"
HOMEPAGE="https://commons.apache.org/proper/commons-lang/"
SRC_URI="mirror://apache/commons/lang/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="2.1"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris"

DEPEND="virtual/jdk:1.8
	test? (
		dev-java/ant-junit:0
	)"

RDEPEND="virtual/jre:1.8"

S="${WORKDIR}/${P}-src"

JAVA_ANT_ENCODING="ISO-8859-1"

src_install() {
	java-pkg_newjar "target/${P}.jar" "${PN}.jar"
	dodoc RELEASE-NOTES.txt NOTICE.txt
	docinto html
	dodoc *.html
	use doc && java-pkg_dojavadoc target/apidocs
	use source && java-pkg_dosrc src/main/java/*
}
