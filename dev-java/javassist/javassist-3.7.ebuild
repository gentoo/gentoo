# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/javassist/javassist-3.7.ebuild,v 1.6 2014/08/10 20:16:42 slyfox Exp $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

# TODO add notes about where the distfile comes from
DESCRIPTION="Javassist makes Java bytecode manipulation simple"
SRC_URI="mirror://sourceforge/jboss/${P}.GA.zip"
HOMEPAGE="http://www.csg.is.titech.ac.jp/~chiba/javassist/"

LICENSE="MPL-1.1"
SLOT="3"
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -v *.jar || die
}

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_DOC_TARGET="javadocs"

src_compile() {
	java-pkg-2_src_compile -Dgentoo.classpath=$(java-config --tools)
}

src_install() {
	java-pkg_dojar ${PN}.jar
	dohtml Readme.html || die
	use doc && java-pkg_dojavadoc html
	use source && java-pkg_dosrc src/main/javassist
}
