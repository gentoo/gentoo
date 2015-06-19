# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jazzy/jazzy-0.5.2.ebuild,v 1.3 2009/03/20 18:54:58 josejx Exp $

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java Spell Check API"
HOMEPAGE="http://sourceforge.net/projects/jazzy"
SRC_URI="mirror://sourceforge/${PN}/${P}.src.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
		app-arch/unzip"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	mkdir dict
	rm -v www/*.jar || die
}

EANT_BUILD_TARGET="library-all"

src_install() {
	java-pkg_dojar dist/lib/*.jar
	dodoc README.txt || die
	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc src/com
	use examples && java-pkg_doexamples --subdir com/swabunga/spell/examples \
		./src/com/swabunga/spell/examples
}
