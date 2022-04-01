# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

MY_PN="pdfbox"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="An open source Java library for parsing font files"
HOMEPAGE="https://pdfbox.apache.org/"
SRC_URI="https://archive.apache.org/dist/pdfbox/${PV}/${MY_P}-src.zip -> ${P}.zip"

LICENSE="BSD"
SLOT="1.7"
KEYWORDS="~amd64 ~arm64 ppc64 ~x86 ~x64-macos"

RDEPEND="
	>=virtual/jre-1.8:*"

DEPEND="
	>=virtual/jdk-1.8:*
	test? (
		dev-java/ant-junit:0
		dev-java/junit:4
	)"

BDEPEND="
	app-arch/unzip"

S="${WORKDIR}/${MY_P}/${PN}"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_TEST_GENTOO_CLASSPATH="junit-4"

src_prepare() {
	default
	cp -v "${FILESDIR}/${P}-build.xml" build.xml || die
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar target/${P}.jar ${PN}.jar

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/org
}
