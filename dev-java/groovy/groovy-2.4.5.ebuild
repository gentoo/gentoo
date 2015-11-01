# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple versionator

MY_PN="${PN^^}"
MY_PV="$(replace_all_version_separators _ ${PV})"
MY_P="${MY_PN}_${MY_PV}"

DESCRIPTION="A multi-faceted language for the Java platform"
HOMEPAGE="http://www.groovy-lang.org/"
SRC_URI="https://github.com/apache/incubator-${PN}/archive/${MY_P}.zip -> ${P}.zip"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

CDEPEND="
	dev-java/jansi:0
	dev-java/xstream:0
	dev-java/commons-cli:1
	>=dev-java/asm-5.0.3:4
	>=dev-java/antlr-2.7.7-r7:0
"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"
DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6
	app-arch/unzip"

JAVA_GENTOO_CLASSPATH="
	asm-4
	antlr
	jansi
	xstream
	commons-cli-1
"

S="${WORKDIR}/incubator-${PN}-${MY_P}"

# ExceptionUtil filename.
EU="ExceptionUtils.java"

# List of antlr grammar files.
ANTLR_GRAMMAR_FILES=(
	org/codehaus/groovy/antlr/groovy.g
	org/codehaus/groovy/antlr/java/java.g
)

# Patches utils.gradle. It basically rewrites ExceptionUtils.
PATCHES=(
	"${FILESDIR}"/"${P}-utils.gradle.patch"
)

# Add target/classes to the CP as we're generating an extra class there.
JAVA_GENTOO_CLASSPATH_EXTRA="target/classes"

# This function cleans up the source directory.
# We're ONLY interested in the "src/main" directory content and nothing else.
# (for the time being).
groovy_cleanup_source_files() {
	ebegin "Cleaning up useless files"
	mv src/main "${T}" || die
	mv gradle/utils.gradle "${T}" || die
	rm -rf * || die
	mv "${T}"/main/* . || die
	rm -rf "${T}"/main || die
	eend $?
}

java_prepare() {
	epatch "${PATCHES[@]}"
	groovy_cleanup_source_files
}

# This function generates the ANTLR grammar files.
generate_antlr_grammar() {
	for grammar_file in "${@}"; do
		local my_grammar_file=$(basename ${grammar_file})

		einfo "Generating \"${my_grammar_file}\" grammar file"
		local my_grammar_dir=$(dirname ${grammar_file})

		cd "${S}/${my_grammar_dir}" || die
		antlr ${my_grammar_file} || die

		cd "${S}" || die
	done
}

# This function generates ExceptionUtils.class.
# ExceptionUtils is a helper class needed when compiling Groovy 2.x.
# Normally, this class is generated via a Gradle task at compile time. Since we
# don't use Gradle here.. we've translated it into a plain Java file and have
# it generate the same data.
generate_exceptionutils() {
	ebegin "Copying ${EU}"
	mv "${T}/utils.gradle" "${EU}" || die
	eend $?

	ejavac -classpath "$(java-pkg_getjar --build-only asm-4 asm.jar)" ${EU}

	ebegin "Running ${EU%.java}"
	$(java-config -J) -classpath "$(java-pkg_getjar --build-only asm-4 asm.jar):." ${EU%.java} || die
	eend $?
}

src_compile() {
	generate_antlr_grammar "${ANTLR_GRAMMAR_FILES[@]}"
	generate_exceptionutils
	java-pkg-simple_src_compile
}

src_install() {
	java-pkg_dolauncher "groovyc" --main org.codehaus.groovy.tools.FileSystemCompiler
	java-pkg_dolauncher "groovy" --main groovy.ui.GroovyMain
	java-pkg-simple_src_install

	# TODO: groovy console and groovy shell are parts of the "subprojects"
	# directory. figure out a way to compile them. :\
	# java-pkg_dolauncher "groovysh" --main groovy.ui.InteractiveShell
	# java-pkg_dolauncher "groovyConsole" --main groovy.ui.Console

	# TODO: grape is written in groovy and to compile it, you need .. groovy.
	# java-pkg_dolauncher "grape" --main org.codehaus.groovy.tools.GrapeMain
}
