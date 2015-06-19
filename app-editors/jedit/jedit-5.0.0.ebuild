# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/jedit/jedit-5.0.0.ebuild,v 1.5 2014/01/03 20:27:46 nimiux Exp $

EAPI=5

JAVA_PKG_IUSE="doc test"

inherit java-pkg-2 java-ant-2 eutils fdo-mime

DESCRIPTION="Programmer's editor written in Java"
HOMEPAGE="http://www.jedit.org"
SRC_URI="mirror://sourceforge/${PN}/${PN}${PV}source.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="amd64 ppc ppc64 x86"
SLOT="0"
IUSE=""

# missing from tarball
RESTRICT="test"

COMMON_DEP="
	dev-java/jsr305:0"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.6"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.6
	dev-java/ant-apache-bsf:0
	dev-java/ant-contrib:0
	dev-java/bsh[bsf]
	test? (
		dev-java/ant-junit:0
	)"

S="${WORKDIR}/jEdit"

JEDIT_HOME="/usr/share/${PN}"

java_prepare() {
	mkdir -p lib/{ant-contrib,compile,default-plugins,scripting} || die

	# don't unconditionally run tests (which aren't even shipped)
	sed -i -e 's|\(depends="init,retrieve,setup,compile\),test|\1|' \
		build.xml || die
}

JAVA_ANT_REWRITE_CLASSPATH="true"

EANT_ANT_TASKS="ant-apache-bsf ant-contrib bsh"
EANT_GENTOO_CLASSPATH="jsr305"
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

src_install () {
	dodir ${JEDIT_HOME}
	cp -R build/${PN}.jar jars doc keymaps macros modes properties startup \
		"${D}${JEDIT_HOME}" || die

	java-pkg_regjar ${JEDIT_HOME}/${PN}.jar

	java-pkg_dolauncher ${PN} --main org.gjt.sp.jedit.jEdit

	use doc && java-pkg_dojavadoc build/classes/javadoc/api

	make_desktop_entry ${PN} \
		jEdit \
		${JEDIT_HOME}/doc/${PN}.png \
		"Development;Utility;TextEditor"

	# keep the plugin directory
	keepdir ${JEDIT_HOME}/jars
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	elog "The system directory for jEdit plugins is"
	elog "${JEDIT_HOME}/jars"
	elog "If you get plugin related errors on startup, first try updating them."
}

pkg_postrm() {
	if [[ -z ${REPLACED_BY_VERSION} ]]; then
		fdo-mime_desktop_database_update
		elog "jEdit plugins installed into /usr/share/jedit/jars"
		elog "(after installation of jEdit itself) haven't been"
		elog "removed. To get rid of jEdit completely, you may"
		elog "want to run"
		elog ""
		elog "    rm -r ${JEDIT_HOME}"
	fi
}
