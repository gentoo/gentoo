# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
WANT_ANT_TASKS="ant-nodeps"
JAVA_PKG_IUSE="doc test examples"
inherit eutils java-pkg-2 java-ant-2

MY_P=${P/-/_}

DESCRIPTION="A Java SSH Client"
HOMEPAGE="http://www.appgate.com/products/80_MindTerm/"
SRC_URI="http://www.appgate.com/downloads/MindTerm-${PV}/${MY_P}-src.zip"

LICENSE="mindterm"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""
COMMON_DEP="dev-java/jzlib:0"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEP}"

S=${WORKDIR}/${MY_P}

JAVA_PKG_FILTER_COMPILER="jikes"
EANT_BUILD_TARGET="mindterm.jar lite"
EANT_DOC_TARGET="doc"
EANT_GENTOO_CLASSPATH="jzlib"
JAVA_ANT_CLASSPATH_TAGS+=" javadoc"

src_prepare() {
	java-pkg-2_src_prepare
	java-ant_rewrite-classpath
	rm -vr com/jcraft || die "Failed to remove bundled jcraft"
}

# Don't even compile
RESTRICT="test"
src_test() {
	ANT_TASKS="ant-junit ant-nodeps" eant test \
		-Dgentoo.classpath="$(java-pkg_getjars jzlib,junit):mindterm.jar"
}

src_install() {
	java-pkg_dojar *.jar

	java-pkg_dolauncher ${PN} --main com.mindbright.application.MindTerm

	dodoc README.txt RELEASE_NOTES.txt CHANGES || die
	use doc && java-pkg_dojavadoc javadoc
	use examples && java-pkg_doexamples "${S}/examples/"
}
