# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/xmlgraphics-commons/xmlgraphics-commons-1.2-r1.ebuild,v 1.2 2014/08/10 20:27:30 slyfox Exp $

JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A library of several reusable components used by Apache Batik and Apache FOP"
HOMEPAGE="http://xmlgraphics.apache.org/commons/index.html"
SRC_URI="mirror://apache/xmlgraphics/commons/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="jpeg"

# fails connect to X even tho it sets java.awt.headless
RESTRICT="test"
CDEPEND=">=dev-java/commons-io-1"
DEPEND="|| ( =virtual/jdk-1.6* =virtual/jdk-1.5* =virtual/jdk-1.4* )
		jpeg? (
			|| (
				>=dev-java/blackdown-jdk-1.4
				=dev-java/icedtea-bin-1*
				>=dev-java/ibm-jdk-bin-1.4
				>=dev-java/jrockit-jdk-bin-1.4
				dev-java/icedtea
				>=dev-java/apple-jdk-bin-1.4
			)
		)
		test? (
			dev-java/ant-junit
		)
		${CDEPEND}"
RDEPEND=">=virtual/jre-1.4
		${CDEPEND}"

# TODO investigate producing .net libraries
# stratigies for non sun jdk's/jre's

pkg_setup() {
	java-pkg-2_pkg_setup

	if use jpeg && java-pkg_current-vm-matches kaffe; then
		eerror "Sun-private JPEG support cannot be built with kaffe."
		eerror "Please set your build VM to Sun, Blackdown, IBM or JRockit JDK."
		eerror "See http://www.gentoo.org/doc/en/java.xml for details."
		eerror "Alternatively, install this package with USE=-jpeg"
		die "Cannot build with USE=jpeg and kaffe."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# automagic bad
	java-ant_ignore-system-classes || die

	cd "${S}/lib" || die
	rm -v *.jar || die

	java-pkg_jarfrom commons-io-1
}

src_compile() {
	local af="-Djdk14.present=true"
	use jpeg && af="${af} -Dsun.jpeg.present=true"
	eant ${af} jar-main $(use_doc javadocs)
}

src_test() {
	java-pkg_jarfrom --into lib junit
	# probably needs ${af} from src_compile, doesn't work anyway
	ANT_TASKS="ant-junit" eant -Djunit.present=true junit
}

src_install(){
	java-pkg_newjar build/${P}.jar
	use source && java-pkg_dosrc src/java/org src/java-1.4/org
	use doc && java-pkg_dojavadoc build/javadocs
}
