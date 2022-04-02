# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc test"

inherit desktop java-pkg-2 java-ant-2 virtualx xdg-utils

MY_PV="${PV/_beta/b}"

DESCRIPTION="Java GUI for managing BibTeX and other bibliographies"
HOMEPAGE="https://www.jabref.org/"
SRC_URI="mirror://sourceforge/${PN}/JabRef-${MY_PV}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

CP_DEPEND="
	dev-java/antlr:0
	dev-java/antlr:3
	dev-java/commons-logging:0
	dev-java/fontbox:1.7
	dev-java/jaxb-api:2
	dev-java/jempbox:1.7
	dev-java/log4j-12-api:2
	dev-java/log4j-api:2
	dev-java/spin:0
	dev-java/microba:0
	>=dev-java/glazedlists-1.8.0:0"

TEST_DEPEND="dev-java/junit:0"

# Since Java 9, all dependencies ever imported by the source files need to be
# present in the classpath for Javadoc generation; in particular, for this
# package, the test sources will be passed to 'javadoc' as well as the non-test
# sources, so all test dependencies are required for Javadoc generation too.
DEPEND="
	>=virtual/jdk-1.8:*
	doc? ( ${TEST_DEPEND} )
	test? ( ${TEST_DEPEND} )
	${CP_DEPEND}"

# Java 17+ requires "--add-opens=java.desktop/java.awt=ALL-UNNAMED" in
# arguments to the JVM that runs this application; Java 8 and 11 are OK,
# but dev-java/java-config currently does not support declaration like
# RDEPEND="|| ( virtual/jre:1.8 virtual/jre:11 )" yet, so only one JRE
# version can be chosen to run this application at the moment.
RDEPEND="
	virtual/jre:1.8
	${CP_DEPEND}"

IDEPEND="dev-util/desktop-file-utils"

S="${WORKDIR}/${PN}-${MY_PV}"

PATCHES=(
	"${FILESDIR}/${P}-javax.swing-java-9+.patch"
	"${FILESDIR}/${P}-skip-failing-tests.patch"
	"${FILESDIR}/${P}-test-jvm-props-args.patch"
)

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_BUILD_TARGET="jars"
EANT_DOC_TARGET="docs"

# Some dependencies that are also used by the tests need to be explicitly
# listed to avoid "package does not exist" compiler errors.
EANT_TEST_GENTOO_CLASSPATH="junit"
EANT_TEST_GENTOO_CLASSPATH+=",antlr-3,commons-logging,glazedlists"
EANT_TEST_GENTOO_CLASSPATH+=",jempbox-1.7,microba,spin"
EANT_TEST_EXTRA_ARGS="-Djava.io.tmpdir=${T} -Duser.home=${HOME}"

src_prepare() {
	default

	# If we cleanup it complains about missing jarbundler
	# BUILD FAILED
	# taskdef class net.sourceforge.jarbundler.JarBundler cannot be found
#	java-pkg_clean

	# Remove bundled dependencies.
	rm lib/antlr*.jar || die
	rm lib/fontbox*.jar || die
	rm lib/glazedlists*.jar || die
	rm lib/jempbox*.jar || die
	rm lib/microba.jar || die
	rm lib/spin.jar || die
	rm lib/plugin/commons-logging.jar || die

	# Remove unjarlib target (do this only once we have removed all
	# bundled dependencies in lib).
	#sed -i -e 's:depends="build, unjarlib":depends="build":' build.xml

	# Fix license file copy operation for microba bundled lib.
	sed -i -e 's:^.*microba-license.*::' build.xml

	use doc && EANT_GENTOO_CLASSPATH_EXTRA="$(\
		java-pkg_getjars --build-only junit)"
}

src_test() {
	# Tests will launch the application, which requires an X environment.
	# An existing application preference file is needed to make the tests
	# non-interactive; otherwise, the application will hang for user input.
	local prefs_dir="${HOME}/.java/.userPrefs/net/sf/jabref"
	mkdir -p "${prefs_dir}" ||
		die "Failed to create application preference directory for tests"
	cp "${FILESDIR}/${P}-test-prefs.xml" "${prefs_dir}/prefs.xml" ||
		die "Failed to copy application preference file for tests"
	virtx java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar build/lib/JabRef-${MY_PV}.jar

	dodoc src/txt/README
	use doc && java-pkg_dojavadoc build/docs/API

	java-pkg_dolauncher ${PN} --main net.sf.jabref.JabRef
	newicon src/images/JabRef-icon-48.png JabRef-icon.png
	make_desktop_entry ${PN} JabRef JabRef-icon Office
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
