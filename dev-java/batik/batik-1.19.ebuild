# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit desktop java-pkg-2 java-pkg-simple verify-sig xdg

DESCRIPTION="XML Graphics Batik"
HOMEPAGE="https://xmlgraphics.apache.org/batik/"
SRC_URI="mirror://apache/xmlgraphics/batik/source/batik-src-${PV}.tar.gz
	verify-sig? ( mirror://apache/xmlgraphics/batik/source/batik-src-${PV}.tar.gz.asc )"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-apache-xmlgraphics )"

CP_DEPEND="
	>=dev-java/rhino-1.9.1:0
	dev-java/xml-commons-external:1.4
	~dev-java/xmlgraphics-commons-2.11:0
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-11:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( CHANGES NOTICE README )

JAVA_RESOURCE_DIRS="resources"
JAVA_SRC_DIR=( ! -path '*test*/src/*' ! -path '*/jacl/*' -path '*/src/main/java/**.java' )
JAVA_TEST_EXCLUDES=(
	# JAXP00010003: The length of entity "%SVG.Presentation.attrib" is "15,002"
	# that exceeds the "15,000" limit set by "jdk.xml.maxParameterEntitySizeLimit".
	org.apache.batik.svg.ValidateDTDTestCase
	# org.apache.batik.test.TestException: Cannot build Test instance of class : . Got exception of class :
	# java.lang.IllegalArgumentException with messages test-references/samples/anne.png and stack trace :
	# java.lang.IllegalArgumentException: test-references/samples/anne.png
	org.apache.batik.test.xml.JUnitRunnerTestCase
)
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS=( batik-util/src/test/resources test-resources )
JAVA_TEST_SRC_DIR=( -path '*/src/test/java/**/*TestCase*.java' )
VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/apache-xmlgraphics.asc"

src_prepare() {
	java-pkg_clean
	java-pkg-2_src_prepare
	# We drop support for jython due to bug #825486.
	rm batik-script/src/main/java/org/apache/batik/script/jpython/JPythonInterpreter.java || die
	rm batik-script/src/main/java/org/apache/batik/script/jpython/JPythonInterpreterFactory.java || die

	cat > "batik-squiggle.desktop" <<-EOF || die
		[Desktop Entry]
		Name=Squiggle
		Comment=SVG browser
		Exec=batik-squiggle
		Icon=init
		Terminal=false
		Type=Application
		Categories=Graphics;VectorGraphics;
		MimeType=image/svg+xml
	EOF

	mkdir resources || die "mkdir"
	# collect resources from all those modules' directories
	local module
	for module in $(find ! -path '*test*/src/*' -path '*/src/main/resources'); do
		pushd "${module}" >/dev/null || die
		find -type f ! -name '*.java' ! -name 'LICENSE' -printf '%P\n' |
			xargs cp --parent -t "${S}"/resources || die "copy resources"
		popd >/dev/null || die
	done
}

src_test() {
	einfo "building batik-test.jar"
	JAVA_GENTOO_CLASSPATH_EXTRA="batik.jar:batik-test.jar"
	JAVA_JAR_FILENAME="batik-test.jar"
	JAVA_SRC_DIR=( -path '**/*test*/**/*.java' )
	java-pkg-simple_src_compile

	einfo "compiling and running tests"
	java-pkg-simple_src_test

	# a mistake in java-pkg-simple.eclass suppresses this test-class
	# but we can run it separately
	JAVA_TEST_RUN_ONLY=( org.apache.batik.util.Base64TestCases )
	java-pkg-simple_src_test
}

src_install() {
	JAVA_JAR_FILENAME="batik.jar" # avoid installing 'batik-test.jar'
	JAVA_SRC_DIR=( batik-* )
	java-pkg-simple_src_install
	domenu "batik-squiggle.desktop"
	newicon -s scalable \
		batik-svgbrowser/src/main/resources/org/apache/batik/apps/svgbrowser/resources/init.svg \
		squiggle.svg

	grep mainClass */pom.xml |
		sed -n 's:.*<mainClass>\(.*\)</mainClass>:\1:p' |
		sort | uniq | while read line
		do
			local launcher=$(echo "${line}" | cut -d. -f 5) || die
			java-pkg_dolauncher "batik-${launcher}" --main "${line}"
		done

	# java_policy_file is copied from previous version
	local java_policy_file="${JAVA_PKG_SHAREPATH}/etc/${PN}.policy"
	insinto "$(dirname "${java_policy_file}")"
	newins - "$(basename "${java_policy_file}")" <<- _EOF_
		grant codeBase "file:${EPREFIX}${JAVA_PKG_JARDEST}/-" {
			permission java.security.AllPermission;
		};
	_EOF_
	java-pkg_register-environment-variable \
		gjl_java_args \
		"\$gjl_java_args -Djava.security.policy=file:${EPREFIX}${java_policy_file}"
}
