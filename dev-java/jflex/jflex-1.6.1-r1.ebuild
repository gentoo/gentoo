# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JFlex is a lexical analyzer generator for Java"
HOMEPAGE="https://www.jflex.de/"
SRC_URI="https://${PN}.de/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~ppc-macos ~x64-macos"
IUSE="examples test vim-syntax"
RESTRICT="!test? ( test )"

CDEPEND="dev-java/ant-core:0"

RDEPEND=">=virtual/jre-1.8:*
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.8:*
	test? ( dev-java/junit:4 )
	${CDEPEND}"

PDEPEND="dev-java/javacup:0"

S="${WORKDIR}/${P}"
JAVA_SRC_DIR="src/main/java"

src_prepare() {
	# See below for details.
	eapply "${FILESDIR}/icedtea-arm.patch"

	# We need the bundled jflex.jar.
	rm -rv ${JAVA_SRC_DIR}/java_cup examples/pom.xml || die

	# Remove the bundled java-cup.jar if unneeded.
	if has_version ${PDEPEND}; then
		rm -v lib/java-cup-*.jar || die
	fi
}

src_configure() {
	# javacup is a cyclic dependency. Use the package if we have it,
	# otherwise use the bundled version and install the package later.
	if has_version ${PDEPEND}; then
		# Use PORTAGE_QUIET to suppress a QA warning that is spurious
		# thanks to has_version above. This is Portage-specific but
		# showing the warning elsewhere isn't the end of the world.
		JAVACUP=$(PORTAGE_QUIET=1 java-pkg_getjar --build-only javacup javacup.jar)
	else
		JAVACUP=$(echo lib/java-cup-*.jar)
	fi

	JAVA_GENTOO_CLASSPATH_EXTRA="$(java-pkg_getjars --build-only ant-core):${JAVACUP}"
}

jflex_compile() {
	java "${@}" jflex.Main -d ${JAVA_SRC_DIR}/${PN} --skel src/main/${PN}/skeleton.nested src/main/${PN}/LexScan.flex || die
	java-pkg-simple_src_compile
	java-pkg_addres ${PN}.jar src/main/resources
}

src_compile() {
	java -jar "${JAVACUP}" -destdir ${JAVA_SRC_DIR}/${PN} -package ${PN} -parser LexParse -interface src/main/cup/LexParse.cup || die

	# The IcedTea ARM HotSpot port (as of 2.6.1) hangs when running
	# jflex. We have patched jflex to fix it but we have to run the
	# bundled version first. -Xint works around the problem. See
	# http://icedtea.classpath.org/bugzilla/show_bug.cgi?id=2678.
	use arm && local JFLEX_ARGS="-Xint"

	# First compile (without doc/source) using the bundled jflex.
	JAVA_PKG_IUSE= jflex_compile -cp "lib/${P}.jar:${JAVACUP}" ${JFLEX_ARGS}

	# Then recompile using the fresh jflex.
	jflex_compile -cp "${PN}.jar:${JAVACUP}"
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dolauncher ${PN} --main ${PN}.Main

	java-pkg_register-dependency javacup javacup-runtime.jar
	java-pkg_register-ant-task

	use examples && java-pkg_doexamples examples
	dodoc {changelog,README}.md

	if use doc; then
		dodoc doc/*.pdf
		docinto html
		dodoc doc/*.{css,html,png} doc/COPYRIGHT
	fi

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins lib/${PN}.vim
	fi
}

src_test() {
	if use arm && java-pkg_current-vm-matches oracle-jdk-bin-1.8; then
		# This results in a StackOverflowError as of 1.8.0.65 but works
		# fine on icedtea:7. Don't know about icedtea:8 yet.
		rm -v src/test/java/jflex/EmitterTest.java || die
	fi

	local CP="src/test/java:${PN}.jar:${JAVA_GENTOO_CLASSPATH_EXTRA}:$(java-pkg_getjars junit-4)"

	local TESTS=$(find src/test/java -name "*Test*.java" -printf "%P\n")
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -classpath "${CP}" $(find src/test/java -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
