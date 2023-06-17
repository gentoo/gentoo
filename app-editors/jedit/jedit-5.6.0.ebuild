# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc test"
inherit desktop java-pkg-2 java-ant-2 xdg-utils

DESCRIPTION="Programmer's editor written in Java"
HOMEPAGE="http://www.jedit.org"
SRC_URI="mirror://sourceforge/project/jedit/jedit/${PV}/jedit${PV}source.tar.bz2"
S="${WORKDIR}/jEdit"

LICENSE="BSD GPL-2"
KEYWORDS="amd64 ppc64 x86"
SLOT="0"

CP_DEPEND="dev-java/jsr305:0"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jdk-11:*"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-11:*
	dev-java/ant-contrib:0
	dev-java/ant-apache-bsf:0
	dev-java/bsh:0
	test? (
		dev-java/ant-junit4:0
		dev-java/hamcrest-library:1.3
		dev-java/mockito:2
	)"

PATCHES=(
	"${FILESDIR}/jedit-5.6.0-skip-failing-test.patch"
	"${FILESDIR}"/jedit-5.4.0-build-xml.patch
)

JEDIT_HOME="/usr/share/${PN}"

src_prepare() {
	default
	mkdir -p lib/{ant-contrib,compile,default-plugins,scripting,test} || die

	java-ant_xml-rewrite -f "${S}/build.xml" -c \
		-e javadoc \
		-a failonerror \
		-v no || die

	java-pkg-2_src_prepare
}

JAVA_ANT_REWRITE_CLASSPATH="true"

EANT_ANT_TASKS="ant-apache-bsf ant-contrib bsh"
EANT_TEST_ANT_TASKS="ant-junit4"
EANT_TEST_GENTOO_CLASSPATH="hamcrest-library-1.3,mockito:2"
EANT_EXTRA_ARGS="-Divy.jar.present=true -Divy.done=true"
# https://bugs.gentoo.org/904034
# EANT_BUILD_TARGET="build docs-html"
EANT_BUILD_TARGET="build"
EANT_DOC_TARGET="generate-javadoc"
# in fact needed only for docs, but shouldn't hurt
EANT_NEEDS_TOOLS="true"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	dodir ${JEDIT_HOME}

	# Conversion to HTML fails and we don't install xml files.
	rm -r doc/{FAQ,whatsnew,users-guide} || die
	cp -R build/${PN}.jar doc keymaps macros modes properties startup \
		"${D}${JEDIT_HOME}" || die

	java-pkg_regjar "${JEDIT_HOME}/${PN}.jar"

	java-pkg_dolauncher "${PN}" --main org.gjt.sp.jedit.jEdit

	use doc && java-pkg_dojavadoc build/classes/javadoc/api

	make_desktop_entry ${PN} \
		jEdit \
		${JEDIT_HOME}/doc/${PN}.png \
		"Development;Utility;TextEditor"
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	if [[ -z ${REPLACED_BY_VERSION} ]]; then
		xdg_desktop_database_update
	fi
}
