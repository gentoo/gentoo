# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2

MY_V=${PV//./_}

DESCRIPTION="JGoodies Animation Library"
HOMEPAGE="http://www.jgoodies.com/"
SRC_URI="http://www.jgoodies.com/download/libraries/animation-${MY_V}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	test? ( dev-java/ant-junit )"

RDEPEND=">=virtual/jre-1.4
	examples? (
		>=dev-java/jgoodies-binding-1.1:1.0
		>=dev-java/jgoodies-forms-1.0:0
	)"

S="${WORKDIR}/animation-${PV}"

EANT_FILTER_COMPILER="jikes"
EANT_DOC_TARGET=""

java_prepare() {
	find -name "*.jar" -delete || die
}

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
