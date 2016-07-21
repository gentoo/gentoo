# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_ANT_REWRITE_CLASSPATH="true"

inherit eutils java-pkg-2 java-ant-2 java-utils-2

MY_PV="${PV/_beta/b}"

DESCRIPTION="Java GUI for managing BibTeX and other bibliographies"
HOMEPAGE="http://jabref.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/JabRef-${MY_PV}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

COMMON_DEP="
	dev-java/antlr:0
	dev-java/antlr:3
	dev-java/fontbox:1.7
	dev-java/jempbox:1.7
	dev-java/log4j:0
	dev-java/spin:0
	dev-java/microba:0
	>=dev-java/glazedlists-1.8.0:0
	"

DEPEND="
	>=virtual/jdk-1.6
	${COMMON_DEP}"

RDEPEND="
	>=virtual/jre-1.6
	${COMMON_DEP}"

S="${WORKDIR}/${PN}-${MY_PV}"

java_prepare() {
	# Remove bundled dependencies.
	rm lib/antlr*.jar || die
	rm lib/fontbox*.jar || die
	rm lib/jempbox*.jar || die
	rm lib/spin.jar || die
	rm lib/microba.jar || die
	rm lib/glazedlists*.jar || die

	# Remove unjarlib target (do this only once we have removed all
	# bundled dependencies in lib).
	#sed -i -e 's:depends="build, unjarlib":depends="build":' build.xml

	# Fix license file copy operation for microba bundled lib.
	sed -i -e 's:^.*microba-license.*::' build.xml
}

src_compile() {
	local EXTERNAL_JARS="antlr,antlr-3,fontbox-1.7,jempbox-1.7,log4j,spin,microba,glazedlists"
	local CLASSPATH="$(java-pkg_getjars --with-dependencies ${EXTERNAL_JARS})"
	eant \
		-Dgentoo.classpath=${CLASSPATH} \
		jars \
		$(usex doc docs "")
}

src_install() {
	java-pkg_newjar build/lib/JabRef-${MY_PV}.jar

	use doc && java-pkg_dojavadoc build/docs/API
	dodoc src/txt/README

	java-pkg_dolauncher ${PN} --main net.sf.jabref.JabRef
	newicon src/images/JabRef-icon-48.png JabRef-icon.png
	make_desktop_entry ${PN} JabRef JabRef-icon Office
}
