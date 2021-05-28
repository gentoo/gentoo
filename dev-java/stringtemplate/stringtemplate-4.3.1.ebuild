# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/antlr/stringtemplate4/archive/refs/tags/4.0.8.tar.gz --slot 4 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild stringtemplate-4.0.8-r2.ebuild

EAPI=7

ANTLR3="3.5.2"
JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.antlr:ST4:4.3.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A Java template engine"
HOMEPAGE="https://www.stringtemplate.org"
SRC_URI="https://github.com/antlr/${PN}4/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://www.antlr3.org/download/antlr-${ANTLR3}-complete.jar"

LICENSE="BSD-1"
SLOT="4"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

# Common dependencies
# POM: pom.xml
# org.antlr:antlr-runtime:3.5.2 -> >=dev-java/antlr-runtime-3.5.2:3.5

DEPEND="
	>=virtual/jdk-1.8:*"
RDEPEND="
	>=virtual/jre-1.8:*"

DOCS=( {CHANGES,README,LICENSE,contributors}.txt )

PATCHES=(
	# Some of the tests require a graphical display.
	"${FILESDIR}"/4.3.1-TestEarlyEvaluation.patch
)

S="${WORKDIR}/${PN}4-${PV}"

# stringtemplate has a cyclic dependency on antlr-3.5.2.
# The downloaded antlr-3.5.2-complete.jar is provided for compilation only.
# No prebuilt software is actually installed onto the system.
JAVA_GENTOO_CLASSPATH_EXTRA="${WORKDIR}/antlr-${ANTLR3}-complete.jar"

JAVA_SRC_DIR="src"

JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="test"
JAVA_TEST_RESOURCE_DIRS="test"

src_prepare() {
	default
	rm -r ../{antlr,META-INF,org} || die # antlr-3.5.2-complete.jar shouldn't be unpacked

	# copy it to a place where we can update its content
	cp "${DISTDIR}/antlr-${ANTLR3}-complete.jar" "${WORKDIR}/" || die
}

src_compile() {
	java -jar "${JAVA_GENTOO_CLASSPATH_EXTRA}" -lib ${JAVA_SRC_DIR}/org/stringtemplate/v4/compiler $(find ${JAVA_SRC_DIR} -name "*.g") || die
	java-pkg-simple_src_compile
}

src_test() {
	# https://github.com/antlr/stringtemplate4/issues/285
	# errors: can't load group file jar:file:/var/tmp/portage/dev-java/stringtemplate-4.3.1/temp/TestImports-1628526315727/dir51535/test.jar!/main.stg

	# remove old org/stringtemplate from antlr-3.5.2-complete.jar
	zip -d ${WORKDIR}/antlr-3.5.2-complete.jar org/stringtemplate/* || die

	# update antlr-3.5.2-complete.jar with fresh compiled org/stringtemplate
	jar --update --file ${WORKDIR}/antlr-3.5.2-complete.jar -C target/classes . || die

	# and finally run the tests
	java-pkg-simple_src_test
}
