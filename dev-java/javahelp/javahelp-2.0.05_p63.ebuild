# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/javahelp/javahelp-2.0.05_p63.ebuild,v 1.5 2012/09/29 17:52:40 grobian Exp $

EAPI="3"

WANT_ANT_TASKS="ant-nodeps"
JAVA_PKG_IUSE="doc examples source"

inherit versionator java-pkg-2 java-ant-2

DESCRIPTION="The JavaHelp system online help system"
HOMEPAGE="https://javahelp.dev.java.net/"

MY_PV="${PV/_p/_svn}"
MY_PN="${PN}2"
SRC_URI="https://${PN}.dev.java.net/files/documents/5985/145533/${MY_PN}-src-${MY_PV}.zip"

LICENSE="GPL-2-with-linking-exception"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris"

COMMON_DEP="
	java-virtuals/servlet-api:2.4"
RDEPEND="
	>=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND="
	>=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEP}"

S="${WORKDIR}/${MY_PN}-${MY_PV}/"
BDIR="${S}/javahelp_nbproject"

src_unpack() {
	unpack ${A}
	# jdic does not currently build out of the box against the browsers we have
	cd "${S}/jhMaster/JavaHelp/src/new/" || die
	rm -v javax/help/plaf/basic/BasicNativeContentViewerUI.java || die
	mkdir "${BDIR}/lib" && cd "${BDIR}/lib" || die
	java-pkg_jar-from --virtual servlet-api-2.4
	java-pkg_filter-compiler jikes
}

_eant() {
	cd ${BDIR} || die
	eant \
		-Dservlet-jar="$(java-pkg_getjar --virtual servlet-api-2.4 servlet-api.jar)" \
		-Djsp-jar="$(java-pkg_getjar --virtual servlet-api-2.4 jsp-api.jar)" \
		-Djdic-jar-present=true \
		-Djdic-zip-present=true \
		-Dtomcat-zip-present=true \
		-Dservlet-jar-present=true \
		${@}
}

src_compile() {
	_eant release $(use_doc)
}

#Does not actually run anything
#src_test() {
#	_eant test
#}

src_install() {
	pushd jhMaster/JavaHelp >/dev/null || die
	java-pkg_dojar "${BDIR}"/dist/lib/*.jar
	java-pkg_dolauncher jhsearch \
		--main com.sun.java.help.search.QueryEngine
	java-pkg_dolauncher jhindexer \
		--main com.sun.java.help.search.Indexer
	use doc && java-pkg_dojavadoc "${BDIR}/dist/lib/javadoc"
	popd >/dev/null || die

	use source && java-pkg_dosrc \
		./jhMaster/JSearch/*/com \
		./jhMaster/JavaHelp/src/*/{javax,com}
	use examples && java-pkg_doexamples jhMaster/JavaHelp/demos
}

pkg_postinst() {
	elog "Native browser integration is disabled because it needs jdic"
	elog "which does not build out of the box. See"
	elog "https://bugs.gentoo.org/show_bug.cgi?id=53897 for progress"
}
