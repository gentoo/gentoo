# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Multi-format schema converter based on RELAX NG"
HOMEPAGE="http://thaiopensource.com/relaxng/trang.html"
SRC_URI="http://jing-trang.googlecode.com/files/${P}.zip"
LICENSE="BSD"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEP="
	dev-java/xerces:2
	dev-java/xml-commons-resolver:0"

RDEPEND="
	>=virtual/jre-1.5
	${COMMON_DEP}"

DEPEND="
	app-arch/unzip
	>=virtual/jdk-1.5
	${COMMON_DEP}"

java_prepare() {
	# need resource files in jar archive so can't remove, see build.xml
	# rm -v *.jar || die "Failed to remove jar archives"

	cp "${FILESDIR}/build.xml" "${S}/build.xml"
}

EANT_GENTOO_CLASSPATH="xerces-2,xml-commons-resolver"

src_test() {
	# a very simple test
	mkdir "test"

	java -jar "dist/${PN}.jar" "${FILESDIR}/test.xml" "test/test.xsd"
	java -jar "dist/${PN}.jar" "${FILESDIR}/test.xml" "test/test.dtd"
	java -jar "dist/${PN}.jar" "test/test.dtd" "test/test.dtd.xsd"

	md5sum -c <<MD5SUMS_END || die "Failed to verify md5sum"
4bcb454ade46c0188f809d2e8ce15315  ${FILESDIR}/test.xml
d096c1fb462902e10a3440a604a21664  test/test.xsd
3fb46bdb16dc75a2a1e36e421b13e51d  test/test.dtd
fce355ca962cb063d7baa5d7fd571bcf  test/test.dtd.xsd
MD5SUMS_END
}

src_install() {
	java-pkg_dojar "dist/${PN}.jar"
	java-pkg_dolauncher trang \
		--main com.thaiopensource.relaxng.translate.Driver
	dohtml *.html || die

	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc src/{org,com}
}
