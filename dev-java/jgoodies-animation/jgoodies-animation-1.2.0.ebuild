# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2

MY_V=${PV//./_}
DESCRIPTION="JGoodies Animation Library"
HOMEPAGE="http://www.jgoodies.com/"
SRC_URI="http://www.jgoodies.com/download/libraries/animation-${MY_V}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	test? ( dev-java/ant-junit )"
# Remove x86 when https://bugs.gentoo.org/show_bug.cgi?id=186081
# is done
RDEPEND=">=virtual/jre-1.4
	examples? ( x86? (
		>=dev-java/jgoodies-binding-1.1
		>=dev-java/jgoodies-forms-1.0
	) )"

S="${WORKDIR}/animation-${PV}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Remove the packaged jar
	rm -v lib/*.jar *.jar || die

	# cp ${FILESDIR}/build-${PV}.xml ${S}
	java-ant_xml-rewrite -f build.xml -d -e javac -a bootclasspath \
		|| die "Failed to fix bootclasspath"
	java-pkg_filter-compiler jikes
}

# precompiled javadocs
EANT_DOC_TARGET=""

src_test() {
	eant test -Djunit.jar.present=true \
		-Djunit.jar=$(java-pkg_getjar junit junit.jar)
}

src_install() {
	java-pkg_dojar build/animation.jar

	dodoc RELEASE-NOTES.txt || die
	dohtml README.html || die
	use doc && java-pkg_dohtml -r docs/*
	use source && java-pkg_dosrc src/core/*
	use examples && java-pkg_doexamples src/tutorial
}
