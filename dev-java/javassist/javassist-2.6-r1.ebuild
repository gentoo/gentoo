# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit java-pkg-2 java-ant-2

DESCRIPTION="Javassist makes Java bytecode manipulation simple"
SRC_URI="mirror://sourceforge/jboss/${P}.zip"
HOMEPAGE="http://www.csg.is.titech.ac.jp/~chiba/javassist/"

LICENSE="MPL-1.1"
SLOT="2"
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="doc source"

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	>=dev-java/ant-core-1.5
	source? ( app-arch/zip )"
S=${WORKDIR}

src_unpack() {
	unpack ${A}
	rm -rf work
}

src_compile() {
	eant jar $(use_doc javadocs)
}

src_install() {
	java-pkg_dojar ${PN}.jar
	java-pkg_dohtml *.html
	use doc && java-pkg_dojavadoc html
	use source && java-pkg_dosrc src/main/javassist
}
