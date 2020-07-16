# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc test"

inherit eutils java-pkg-2 java-ant-2 xdg-utils

DESCRIPTION="Programmer's editor written in Java"
HOMEPAGE="http://www.jedit.org"
SRC_URI="mirror://sourceforge/${PN}/${PN}${PV}source.tar.bz2"

LICENSE="BSD GPL-2"
KEYWORDS="~amd64 ~ppc64 ~x86"
SLOT="0"

CP_DEPEND="dev-java/jsr305:0"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8
	dev-java/ant-contrib:0
	dev-java/ant-apache-bsf:0
	dev-java/bsh:0
	test? (
		dev-java/ant-junit:0
		dev-java/hamcrest-library:1.3
	)"

S="${WORKDIR}/jEdit"

JEDIT_HOME="/usr/share/${PN}"

src_prepare() {
	mkdir -p lib/{ant-contrib,compile,default-plugins,scripting,test} || die

	eapply "${FILESDIR}"/${P}-build-xml.patch

	java-ant_xml-rewrite -f "${S}/build.xml" -c \
		-e javadoc \
		-a failonerror \
		-v no || die

	java-pkg-2_src_prepare
}

JAVA_ANT_REWRITE_CLASSPATH="true"

EANT_ANT_TASKS="ant-apache-bsf ant-contrib bsh"
EANT_TEST_GENTOO_CLASSPATH="hamcrest-library-1.3"
EANT_EXTRA_ARGS="-Divy.jar.present=true -Divy.done=true"
EANT_BUILD_TARGET="build"
# TODO could build more docs, ie generate-doc-faq generate-doc-news
# generate-doc-users-guide ua.
EANT_DOC_TARGET="generate-javadoc"
# in fact needed only for docs, but shouldn't hurt
EANT_NEEDS_TOOLS="true"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	dodir ${JEDIT_HOME}

	cp -R build/${PN}.jar jars doc keymaps macros modes properties startup \
		"${D}${JEDIT_HOME}" || die

	java-pkg_regjar "${JEDIT_HOME}/${PN}.jar"

	java-pkg_dolauncher "${PN}" --main org.gjt.sp.jedit.jEdit

	use doc && java-pkg_dojavadoc build/classes/javadoc/api

	make_desktop_entry ${PN} \
		jEdit \
		${JEDIT_HOME}/doc/${PN}.png \
		"Development;Utility;TextEditor"

	# keep the plugin directory
	keepdir ${JEDIT_HOME}/jars
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
