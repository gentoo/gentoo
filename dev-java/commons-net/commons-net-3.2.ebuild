# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-net/commons-net-3.2.ebuild,v 1.3 2014/08/10 20:11:53 slyfox Exp $

EAPI="5"

# http://issues.apache.org/bugzilla/show_bug.cgi?id=37985
RESTRICT="test"
JAVA_PKG_IUSE="doc examples source" # test

inherit eutils java-pkg-2 java-ant-2 java-osgi

MY_P="${P}-src"

DESCRIPTION="The purpose of the library is to provide fundamental protocol access, not higher-level abstractions"
HOMEPAGE="http://commons.apache.org/net/"
SRC_URI="mirror://apache/commons/net/source/${MY_P}.tar.gz"

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

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
