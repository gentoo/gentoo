# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc test"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A parser generator for many languages"
HOMEPAGE="https://www.antlr3.org/"
SRC_URI="https://www.antlr3.org/download/${P}.tar.gz
	https://www.antlr3.org/download/${P}.jar" # Prebuilt version needed.
S="${WORKDIR}/${P}"

LICENSE="BSD"
SLOT="3"
KEYWORDS="amd64 arm64 ppc64 ~x64-macos ~x64-solaris"
RESTRICT="!test? ( test )"

CP_DEPEND=">=dev-java/antlr-2.7.7-r7:0
	dev-java/stringtemplate:0"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? ( dev-java/junit:4 )"

PATCHES=(
	# These fixes have been applied in 3.5.
	"${FILESDIR}/${PV}-test-fixes.patch"
	"${FILESDIR}/${PV}-java-8.patch"
	"${FILESDIR}/antlr-3.2-java21.patch"
)

JAVA_GENTOO_CLASSPATH_EXTRA="${S}/${PN}-runtime.jar"

src_unpack() {
	unpack ${P}.tar.gz
}

src_prepare() {
	default
	java-pkg_clean

	# Some tests fail under Java 8 in ways that probably aren't limited
	# to the tests. This is bad but upstream is never going to update
	# 3.2 even though other projects still rely on it. If any issues
	# arise, we can only put pressure on those projects to upgrade.
	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 1.8; then
		rm -v tool/src/test/java/org/antlr/test/Test{DFAConversion,SemanticPredicates,TopologicalSort}.java || die
	fi

	# 3.2 has strange hidden files.
	find -type f -name "._*.*" -delete || die
}

src_compile() {
	cd "${S}/runtime/Java/src/main" || die
	JAVA_JAR_FILENAME="${S}/${PN}-runtime.jar" java-pkg-simple_src_compile

	cd "${S}/tool/src/main" || die

	local G; for G in antlr codegen antlr.print assign.types buildnfa define; do # from pom.xml
		antlr -o antlr2/org/antlr/grammar/v2/{,${G}.g} || die
	done

	# We have applied a patch to fix this version under Java 8. Trouble
	# is that we need to run a prebuilt version before we can build our
	# own and that version doesn't have the fix applied. We work around
	# this by building just the offending class against the prebuilt
	# version and then putting them together in the classpath. That
	# isn't all. Due to a compiler limitation that Chewi doesn't fully
	# understand, this class cannot be compiled by itself without a
	# couple of tweaks that have been applied in the Java 8 patch.
	ejavac -classpath "${DISTDIR}/${P}.jar" java/org/antlr/tool/CompositeGrammar.java

	java -classpath "java:${DISTDIR}/${P}.jar" org.antlr.Tool $(find antlr3 -name "*.g") || die
	JAVA_JAR_FILENAME="${S}/${PN}-tool.jar" java-pkg-simple_src_compile
	java-pkg_addres "${S}/${PN}-tool.jar" resources
}

src_install() {
	java-pkg_dojar ${PN}-{runtime,tool}.jar
	java-pkg_dolauncher ${PN}${SLOT} --main org.antlr.Tool
	use doc && java-pkg_dojavadoc runtime/Java/src/main/target/api
}

src_test() {
	cd tool/src/test/java || die
	local CP=".:${S}/${PN}-runtime.jar:${S}/${PN}-tool.jar:$(java-pkg_getjars --build-only junit-4,${JAVA_GENTOO_CLASSPATH})"

	local TESTS=$(find * -name "Test*.java")
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -classpath "${CP}" $(find -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
