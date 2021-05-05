# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

JAVA_PKG_IUSE="doc test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A visual and cross-platform MIPS64 CPU Simulator"
HOMEPAGE="https://www.edumips.org"
SLOT="0"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-java/javatoolkit
	dev-java/javahelp:0
	>=virtual/jdk-1.8
	test? (
		dev-java/junit:4
		dev-java/ant-junit4
	)"
RDEPEND=">=virtual/jre-1.8"
BDEPEND="
	dev-python/sphinx
	doc? ( sys-devel/make )"

EANT_BUILD_TARGET="slim-jar"
EANT_DOC_TARGET="htmldoc"

PATCHES=( "${FILESDIR}/${P}-javadoc-cp.patch" )

src_prepare() {
	java-pkg_jar-from --build-only --into libs javahelp jhall.jar
	use test && java-pkg_jar-from --build-only --into libs junit-4 junit.jar junit-4.10.jar
	java-pkg-2_src_prepare
}

src_install() {
	java-pkg_newjar ${PN}-${PV}-nodeps.jar ${PN}.jar
	dodoc RELEASE_NOTES authors
	use doc && java-pkg_dojavadoc docs/en/output/html
}

src_test() {
	ANT_TASKS="ant-junit4" eant test
}
