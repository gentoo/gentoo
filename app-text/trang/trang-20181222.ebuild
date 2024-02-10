# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2 java-ant-2 prefix

DESCRIPTION="Multi-format schema converter based on RELAX NG"
HOMEPAGE="http://thaiopensource.com/relaxng/trang.html"
SRC_URI="https://github.com/relaxng/jing-trang/archive/V${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/jing-${P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

COMMON_DEP="
	dev-java/xerces:2
	dev-java/xml-commons-resolver:0"
RDEPEND="
	>=virtual/jre-1.8:*
	${COMMON_DEP}"
DEPEND="
	>=virtual/jdk-1.8:*
	dev-java/javacc:0
	dev-java/saxon:6.5
	dev-java/testng:0
	${COMMON_DEP}"
BDEPEND="app-i18n/unicode-data"

EANT_ANT_TASKS="testng"
EANT_GENTOO_CLASSPATH="xerces-2,xml-commons-resolver"
JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_PKG_BSFIX_NAME="build.xsl"

PATCHES=(
	"${FILESDIR}"/${PN}-20181222-build-fixes.patch
	"${FILESDIR}"/${PN}-20181222-unicode-data-path.patch
)

src_prepare() {
	default

	eprefixify mod/regex/mod.xml

	java-pkg_clean
	echo "<version>${PV}</version>" > version.xml || die
}

src_configure() {
	java-ant-2_src_configure

	# Because this crazy package uses XSLT, we need to escape this.
	sed -i 's:\${gentoo\.classpath}:${{gentoo.classpath}}:g' build.xsl || die

	EANT_EXTRA_ARGS="-Djavacc.dir=${EPREFIX}/usr/share/javacc/lib"
	export LOCALCLASSPATH=$(java-pkg_getjars --build-only --with-dependencies saxon-6.5)
}

src_compile() {
	EANT_BUILD_TARGET="modbuild trang-doc" java-pkg-2_src_compile
	EANT_BUILD_TARGET="mod.trang.jar" EANT_BUILD_XML="modbuild.xml" java-pkg-2_src_compile
}

src_test() {
	java -jar build/${PN}.jar "${FILESDIR}/test.xml" test/test.xsd || die
	java -jar build/${PN}.jar "${FILESDIR}/test.xml" test/test.dtd || die
	java -jar build/${PN}.jar test/test.dtd test/test.dtd.xsd || die

	md5sum -c <<EOF || die "Failed to verify md5sum"
4bcb454ade46c0188f809d2e8ce15315  ${FILESDIR}/test.xml
d096c1fb462902e10a3440a604a21664  test/test.xsd
3fb46bdb16dc75a2a1e36e421b13e51d  test/test.dtd
fce355ca962cb063d7baa5d7fd571bcf  test/test.dtd.xsd
EOF
}

src_install() {
	java-pkg_dojar build/${PN}.jar
	java-pkg_dolauncher ${PN} \
		--main com.thaiopensource.relaxng.translate.Driver

	docinto html
	dodoc build/*.html
}
