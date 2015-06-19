# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/miglayout/miglayout-4.0.ebuild,v 1.4 2012/06/01 06:45:52 jdhore Exp $

EAPI="4"

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2

DESCRIPTION="Easy to use yet very powerful Java Swing layout manager"
HOMEPAGE="http://www.miglayout.com/"
SRC_URI="http://www.migcalendar.com/miglayout/versions/${PV}/${P}-sources.jar"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="swt"

COMMON_DEP="
	swt? ( dev-java/swt:3.7 )"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.5"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.5
	app-arch/unzip"

S="${WORKDIR}"

java_prepare() {
	mv net/miginfocom/{demo,examples} . || die
	mv demo/* examples || die

	if ! use swt; then
		rm -r net/miginfocom/swt || die
	fi

	find net -name '*.java' > sources.lst
}

src_compile() {
	local classpath
	use swt && classpath=( -classpath "$(java-pkg_getjars swt-3.7)" )

	mkdir classes || die
	ejavac "${classpath[@]}" -d classes @sources.lst || die
	jar -cf ${PN}.jar -C classes . || die

	if use doc; then
		javadoc "${classpath[@]}" -author -version -d api @sources.lst || die
	fi
}

src_install() {
	java-pkg_dojar ${PN}.jar

	use doc && java-pkg_dojavadoc api
	use examples && java-pkg_doexamples examples
	use source && java-pkg_dosrc net
}
