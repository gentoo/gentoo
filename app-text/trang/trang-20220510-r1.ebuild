# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc test"
JAVA_TESTING_FRAMEWORKS="testng"

inherit java-pkg-2 java-pkg-simple prefix

DESCRIPTION="Multi-format schema converter based on RELAX NG"
HOMEPAGE="http://thaiopensource.com/relaxng/trang.html"
SRC_URI="https://github.com/relaxng/jing-trang/archive/V${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/jing-${P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="
	app-i18n/unicode-data
	dev-java/saxon:9
"
CP_DEPEND="
	dev-java/xerces:2
	dev-java/xml-commons-resolver:0
"
RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"
JAVACC_SLOT="7.0.13"

#934306  restrict to >=virtual/jdk-11:*
DEPEND="${CP_DEPEND}
	dev-java/javacc:${JAVACC_SLOT}
	dev-java/testng:0
	>=virtual/jdk-11:*"

JAVA_TEST_RESOURCE_DIRS="src/test"
JAVA_TEST_SRC_DIR="src/test"

src_prepare() {
	java-pkg-2_src_prepare
	java-pkg_clean

	eprefixify mod/regex/mod.xml	# Do we still need this?

	# separating some sources which are needed only for compilation
	mkdir helper || die
	cp -r mod/{catalog,datatype,jaxp,pattern,resolver,rng-parse}/src helper || die

	# most of the mods are not needed for the final trang.jar
	rm -r mod/{dtdinst,nvdl,picl,rng-jarv,rng-validate,schematron,validate,xerces} || die
	rm -r mod/{jaxp,pattern,rng-jaxp} || die

	# move all remainig stuff to "src/main" resp. "src/test"
	mkdir -p resources src meta/META-INF/services || die
	mv {mod/,}regex-gen || die	# but not this one which is needed in two JAVA_SRC_DIRs
	cp -r mod/*/src/{main,test} src || die

	# populate META-INF/services
	echo com.thaiopensource.datatype.xsd.DatatypeLibraryFactoryImpl \
		> meta/META-INF/services/org.relaxng.datatype.DatatypeLibraryFactory || die
	echo com.thaiopensource.datatype.xsd.regex.xerces2.RegexEngineImpl \
		> meta/META-INF/services/com.thaiopensource.datatype.xsd.regex.RegexEngine || die

	echo "version=${PV}" \
		> src/main/com/thaiopensource/relaxng/translate/resources/Version.properties || die

	# java-pkg-simple expects resources in JAVA_RESOURCE_DIRS
	find src -type f ! -name '*.java' ! -name 'CompactSyntax.jj' ! -name 'package.html' \
		| xargs cp --parent -t resources || die

	# code generation according to mod/rng-parse/mod.xml
	local OUT_DIR="gensrc/main/com/thaiopensource/relaxng/parse/compact"
	mkdir -p "${OUT_DIR}"
	"javacc-${JAVACC_SLOT}" -GRAMMAR_ENCODING=UTF-8 \
		-JDK_VERSION=1.8 \
		-OUTPUT_DIRECTORY="${OUT_DIR}" \
		helper/src/main/com/thaiopensource/relaxng/parse/compact/CompactSyntax.jj \
		|| die "Code generation with java.jj failed"
	rm "${OUT_DIR}/JavaCharStream.java" || die

	# mod/rng-parse/mod.xml lines 16-17 - 's/java.io.IOException/EOFException/'
	eapply "${FILESDIR}/trang-20220510-CompactSyntaxTokenManager.patch" || die
}

src_compile() {
	einfo "Compiling some classes needed for code generation"
	ejavac -d util \
		$(find regex-gen/src/main mod/util/src/main -name "*.java") || die

	einfo "Code generation"
	"$(java-config -J)" -cp "util" \
		com.thaiopensource.datatype.xsd.regex.java.gen.NamingExceptionsGen \
		"com.thaiopensource.datatype.xsd.regex.java.NamingExceptions" \
		"src/main" || die

	"$(java-config -J)" -cp "util" \
		com.thaiopensource.datatype.xsd.regex.java.gen.CategoriesGen \
		"com.thaiopensource.datatype.xsd.regex.java.Categories" \
		"src/main" \
		"/usr/share/unicode-data/UnicodeData.txt" || die

	einfo "Compiling classes which are not needed for the final trang.jar"
	ejavac -d helper \
		-cp "util:$(java-pkg_getjars --build-only xml-commons-resolver)" \
		$(find gensrc/main helper/src/main -name "*.java") || die

	einfo "Compiling trang.jar"
	JAVA_CLASSPATH_EXTRA="testng"
	JAVA_GENTOO_CLASSPATH_EXTRA="util:helper"
	JAVA_JAR_FILENAME="trang.jar"
	JAVA_MAIN_CLASS="com.thaiopensource.relaxng.translate.Driver"
	JAVA_RESOURCE_DIRS=( meta resources/src/main )
	JAVA_SRC_DIR=( {gen,}src/main )
	java-pkg-simple_src_compile
}
