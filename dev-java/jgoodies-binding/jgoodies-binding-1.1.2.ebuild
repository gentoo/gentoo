# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

MY_V=${PV//./_}
DESCRIPTION="A Java library to bind object properties with UI components"
HOMEPAGE="http://www.jgoodies.com/"
SRC_URI="http://www.jgoodies.com/download/libraries/binding-${MY_V}.zip"

LICENSE="BSD"
SLOT="1.0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND=">=virtual/jdk-1.4.2
		app-arch/unzip"
RDEPEND=">=virtual/jre-1.4.2
		examples? ( >=dev-java/jgoodies-looks-1.0.5 )"

S=${WORKDIR}/binding-${PV}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Clean up the directory structure
	rm -rvf *.jar lib

	# Copy the Gentoo'ized build.xml
	# cp ${FILESDIR}/build-${PV}.xml ${S}
	java-ant_xml-rewrite -f build.xml -d -e javac -a bootclasspath
	#	|| die "Failed to fix bootclasspath"
	java-pkg_filter-compiler jikes
}

src_compile() {
	eant jar # precompile javadocs
}

RESTRICT="test"
# Needs X
#src_test() {
#	eant test -D\
#		-Djunit.jar=$(java-pkg_getjar junit junit.jar)
#}

src_install() {
	java-pkg_dojar build/binding.jar

	dodoc RELEASE-NOTES.txt || die
	dohtml README.html || die
	use doc && java-pkg_dohtml -r docs/*
	use source && java-pkg_dosrc src/core/*
	use examples && java-pkg_doexamples src/tutorial
}
