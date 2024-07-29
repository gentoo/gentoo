# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="CUP Parser Generator for Java"
HOMEPAGE="https://www2.cs.tum.edu/projects/cup/"
SRC_URI="https://www2.cs.tum.edu/projects/cup/releases/java-cup-src-${PV/_p/-}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="ant-task"

DEPEND="${CP_DEPEND}
	>=dev-java/jflex-1.6.1-r3:0
	>=virtual/jdk-1.8:*
	ant-task? ( >=dev-java/ant-1.10.14-r3:0 )"
RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*
	ant-task? ( >=dev-java/ant-1.10.14-r3:0 )"

DOCS=( changelog.txt )
HTML_DOCS=( manual.html )

JAVA_MAIN_CLASS="java_cup/Main"
JAVA_SRC_DIR=( "src" "java" )

src_prepare() {
	java-pkg-2_src_prepare
	if use ant-task; then
		JAVA_GENTOO_CLASSPATH+="ant"
	else
		rm src/java_cup/anttask/CUPTask.java || die
	fi
}

src_compile() {
	if has_version \>=${CATEGORY}/${PN}-11b:${SLOT}; then
		einfo "Get path of installed JAVACUP"
		CP_CUP="$(java-pkg_getjar --build-only javacup javacup.jar)"
	else
		einfo "Get path of bundled JAVACUP"
		CP_CUP="$(echo bin/java-cup-*.jar)"
	fi
	einfo "Path to JAVACUP is ${CP_CUP}"

	einfo "Get path to jflex"
	CP_FLEX="$(java-pkg_getjars --build-only jflex)"
	einfo "Path to jflex is ${CP_FLEX}"

	einfo "Generate parser with: ${CP_CUP}"
	"$(java-config -J)" -jar "${CP_CUP}" \
		-interface -destdir "java" -parser "parser" -symbols "sym" \
		cup/parser.cup || die

	einfo "Generate lexer"
	# https://jflex.de/manual.html#running-jflex
	$(java-config -J) -cp "${CP_CUP}:${CP_FLEX}" jflex.Main \
		flex/Lexer.jflex -d java/javacup || die

	einfo "Build intermediate jar"
	JAVA_JAR_FILENAME="seco.jar"
	java-pkg-simple_src_compile

	einfo "Remove classes and generated code"
	rm -rv java/* target/classes/ || die

	einfo "Regenerate parser with intermediate jar file"
	"$(java-config -J)" -jar ./seco.jar \
		-interface -destdir "java" -parser "parser" -symbols "sym" \
		cup/parser.cup || die

	einfo "Regenerate lexer with intermediate jar file"
	$(java-config -J) -cp "$(echo ./seco.jar):${CP_FLEX}" jflex.Main \
		flex/Lexer.jflex -d java/javacup || die

	einfo "Build final jar with regenerated parser and lexer"
	JAVA_JAR_FILENAME="${PN}.jar"
	java-pkg-simple_src_compile
	"$(java-config --jar)" cvf "${PN}-runtime.jar" -C target/classes java_cup/runtime || die
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dojar "${PN}.jar" "${PN}-runtime.jar"
	use ant-task && java-pkg_register-ant-task
}
