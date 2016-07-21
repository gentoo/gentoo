# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc test"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A visual and cross-platform MIPS64 CPU Simulator"
HOMEPAGE="http://www.edumips.org"
SLOT="0"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/sphinx
	dev-java/javahelp:0
	>=virtual/jdk-1.6
	doc? ( sys-devel/make )
	test? (
		dev-java/junit:4
		dev-java/ant-junit4
	)"
RDEPEND=">=virtual/jre-1.6"

EANT_BUILD_TARGET="slim-jar"
EANT_DOC_TARGET="htmldoc"

src_prepare() {
	epatch "${FILESDIR}/${PN}-javadoc-cp.patch"
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
