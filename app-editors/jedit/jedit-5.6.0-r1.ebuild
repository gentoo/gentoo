# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit desktop java-pkg-2 java-pkg-simple xdg-utils

DESCRIPTION="Programmer's editor written in Java"
HOMEPAGE="https://www.jedit.org"
SRC_URI="mirror://sourceforge/project/jedit/jedit/${PV}/jedit${PV}source.tar.bz2"
S="${WORKDIR}/jEdit"

LICENSE="BSD GPL-2"
KEYWORDS="~amd64 ~ppc64 ~x86"
SLOT="0"

BDEPEND="
	app-text/docbook-xsl-stylesheets:0
	dev-libs/libxslt:0
"
CP_DEPEND="dev-java/jsr305:0"
DEPEND="${CP_DEPEND}
	>=virtual/jdk-11:*
	test? (
		dev-java/hamcrest:0
		dev-java/mockito:2
	)"
RDEPEND="${CP_DEPEND}
	>=virtual/jre-11:*"

PATCHES=( "${FILESDIR}/jedit-5.6.0-skip-failing-test.patch" )

JAVA_MAIN_CLASS="org.gjt.sp.jedit.jEdit"
JAVA_RESOURCE_DIRS="resources"
JAVA_SRC_DIR="src"
JAVA_TEST_GENTOO_CLASSPATH="
	hamcrest
	junit-4
	mockito-2
"
JAVA_TEST_SRC_DIR="test"
JEDIT_HOME="/usr/share/${PN}/lib"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	mkdir -v src resources || die
	find org doclet -type f -name '*.java' \
		| xargs cp --parent -t "${JAVA_SRC_DIR}" || die
	find org -type f \
		! -name '*.java' \
		! -name 'package.html' \
		! -name 'README.html' \
		! -name 'jedit.manifest' \
		! -name 'Reflect.last' \
		! -name 'bsh.jj*' \
		! -name '*.scripted' \
		| xargs cp --parent -t "${JAVA_RESOURCE_DIRS}" || die

	einfo "Creating the docs"
	mv doc/{FAQ,whatsnew} . || die
	mkdir doc/{FAQ,whatsnew} || die
	# build.xml 734-804
	xsltproc \
		-xinclude \
		-o doc/FAQ/ \
		doc/jedithtml.xsl \
		FAQ/faq.xml || die
	xsltproc \
		-o doc/whatsnew/ \
		doc/jedithtml.xsl \
		whatsnew/news.xml || die

	einfo "Creating users-guide"
	ln -s /usr/share/sgml/docbook/ . || die
	# This is the part which does not work with xmlto. So we use xsltproc.
	# TODO:
	# Try "XIncludes with Xalan and Xerces" according to
	# http://www.sagehill.net/docbookxsl/Xinclude.html#d0e40343
	xsltproc \
		-xinclude \
		-o doc/users-guide/users-guide.html \
		docbook/xsl-stylesheets/html/docbook.xsl \
		doc/jedithtml.xsl \
		doc/users-guide/users-guide.xml || die
	# Cleanup. The xml files were processed and need not get installed.
	rm doc/users-guide/*.xml || die
}

src_install() {
	java-pkg-simple_src_install
	# The application wants all this stuff in /usr/share/jedit/lib/
	# Using java-pkg_dolauncher with --pwd cannot solve it.
	# If we change the location the application fails to start:
	# "System keymap folder do not exist, your installation is broken."
	cp -R jars doc keymaps macros modes properties startup \
		"${D}${JEDIT_HOME}" || die

	make_desktop_entry "${PN}" jEdit \
		"${JEDIT_HOME}/doc/${PN}.png" \
		"Development;Utility;TextEditor"

	# keep the plugin directory
	keepdir "${JEDIT_HOME}/jars"
}

pkg_postinst() {
	xdg_desktop_database_update
	elog "The system directory for jEdit plugins is"
	elog "${JEDIT_HOME}/jars"
	elog "If you get plugin related errors on startup, first try updating them."
}

pkg_postrm() {
	if [[ -z ${REPLACED_BY_VERSION} ]]; then
		xdg_desktop_database_update
		elog "jEdit plugins installed into /usr/share/jedit/jars"
		elog "(after installation of jEdit itself) haven't been"
		elog "removed. To get rid of jEdit completely, you may"
		elog "want to run"
		elog ""
		elog "    rm -r ${JEDIT_HOME}"
	fi
}
