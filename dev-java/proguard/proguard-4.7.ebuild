# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Free Java class file shrinker, optimizer, and obfuscator"
HOMEPAGE="http://proguard.sourceforge.net/"
MY_P=${P/-/}
MY_P=${MY_P/_/}
SRC_URI="mirror://sourceforge/proguard/${MY_P}.tar.gz"

LICENSE="GPL-2-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE="ant j2me"

DEPEND=">=virtual/jdk-1.4
		j2me? ( >=dev-java/sun-j2me-bin-2.2:0 )"
RDEPEND=">=virtual/jre-1.4
		>=dev-java/ant-core-1.7:0
		j2me? ( >=dev-java/sun-j2me-bin-2.2:0 )"

S=${WORKDIR}/${MY_P}

java_prepare() {
	find "${S}" -name "*.jar" | xargs rm -v
}

EANT_BUILD_XML="build/build.xml"
EANT_BUILD_TARGET="basic"
EANT_DOC_TARGET=""

src_compile() {
	local j2mearg antarg

	use ant && antarg="-Dant.jar=$(java-pkg_getjar ant-core ant.jar)"
	use j2me && j2mearg="-Dwtk.jar=$(java-pkg_getjar sun-j2me-bin kenv.zip)"

	java-pkg-2_src_compile \
		$(use ant && echo anttask ${antarg}) \
		$(use j2me && echo wtkplugin ${j2mearg})

	if use doc; then
		mkdir javadoc || die
		javadoc -d javadoc -sourcepath src -classpath $${cp} -subpackages proguard || die "Cannot compile javadoc"
	fi
}

src_install() {
	java-pkg_dojar lib/*
	java-pkg_dolauncher ${PN} --main proguard.ProGuard
	java-pkg_dolauncher ${PN}gui --main proguard.gui.ProGuardGUI
	java-pkg_dolauncher ${PN}_retrace --main proguard.retrace.ReTrace

	if use doc; then
		dohtml -r docs/*
		java-pkg_dojavadoc javadoc
	fi

	use examples && java-pkg_doexamples examples
}
