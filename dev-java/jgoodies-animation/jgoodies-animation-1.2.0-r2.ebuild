# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2

MY_V=${PV//./_}

DESCRIPTION="JGoodies Animation Library"
HOMEPAGE="http://www.jgoodies.com/"
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	app-arch/unzip
	>=virtual/jdk-1.6
	test? ( dev-java/ant-junit:0 )"

RDEPEND="
	>=virtual/jre-1.6
	examples? (
		>=dev-java/jgoodies-binding-1.1:1.0
		>=dev-java/jgoodies-forms-1.0:0
	)"

S="${WORKDIR}/animation-${PV}"

EANT_FILTER_COMPILER="jikes"
EANT_DOC_TARGET=""

DOCS=( RELEASE-NOTES.txt README.html )

src_prepare() {
	default

	java-pkg_clean
}

src_test() {
	eant test -Djunit.jar.present=true \
		-Djunit.jar=$(java-pkg_getjar junit junit.jar)
}

src_install() {
	java-pkg_dojar build/animation.jar
	einstalldocs
	use doc && java-pkg_dohtml -r docs/*
	use source && java-pkg_dosrc src/core/*
	use examples && java-pkg_doexamples src/tutorial
}
