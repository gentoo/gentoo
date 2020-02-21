# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Woodstox is a high-performance validating namespace-aware XML-processor"
HOMEPAGE="https://github.com/FasterXML/woodstox"
SRC_URI="mirror://gentoo/${PN}-src-${PV}.zip"
LICENSE="Apache-2.0"
SLOT="3.2"
KEYWORDS="amd64 ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

CDEPEND="
	dev-java/sax:0
	dev-java/msv:0
	dev-java/relaxng-datatype:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	test? ( dev-java/ant-junit:0 )
	app-arch/unzip
	>=virtual/jdk-1.6"

EANT_BUILD_TARGET="jars"
EANT_DOC_TARGET="javadoc"

# Don't need to make a folder
S="${WORKDIR}"

JAVA_ANT_REWRITE_CLASSPATH="true"

java_prepare() {
	rm -v lib/msv/*.jar || die
	rm -v lib/*.jar || die

	# Get rid of a missing include.
	epatch "${FILESDIR}"/${P}-build.xml.patch
}

EANT_GENTOO_CLASSPATH="sax,msv,relaxng-datatype"

src_test(){
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar build/"${PN}"-api-"${PV}".jar "${PN}"-api.jar
	java-pkg_newjar build/"${PN}"-asl-"${PV}".jar "${PN}".jar
	use doc && java-pkg_dojavadoc build/javadoc
	use source && java-pkg_dosrc src
}
