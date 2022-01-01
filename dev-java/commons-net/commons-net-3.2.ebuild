# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

# http://issues.apache.org/bugzilla/show_bug.cgi?id=37985
RESTRICT="test"
JAVA_PKG_IUSE="doc examples source" # test

inherit java-pkg-2 java-ant-2 java-osgi

MY_P="${P}-src"

DESCRIPTION="Java library emulating the client side of many basic Internet protocols"
HOMEPAGE="http://commons.apache.org/net/"
SRC_URI="mirror://apache/commons/net/source/${MY_P}.tar.gz"

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

S="${WORKDIR}/${MY_P}"

java_prepare() {
	cp "${FILESDIR}"/${P}-build.xml build.xml || die
	sed -i 's/depends="compile,test"/depends="compile"/' build.xml || die "Failed to disable junit"
	sed -i 's/manifest=".*MANIFEST.MF"//g' build.xml || die
	sed -i '/name="Main-Class"/d' build.xml || die
}

src_install() {
	java-osgi_newjar target/${P}.jar ${P} ${P} "Export-Package: ${P}"

	use doc && java-pkg_dojavadoc target/site/apidocs
	use examples && java-pkg_doexamples src/main/java/examples
	use source && java-pkg_dosrc src/main/java/org
}
