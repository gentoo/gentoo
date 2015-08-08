# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 elisp eutils

DESCRIPTION="Java Development Environment for Emacs"
HOMEPAGE="http://jdee.sourceforge.net/"
# snapshot of svn://svn.code.sf.net/p/jdee/code/branches/2.4.1 (rev 292)
# (upstream's distfile misses build.xml)
SRC_URI="mirror://gentoo/jdee-${PV}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

RDEPEND=">=virtual/jdk-1.3
	app-emacs/elib
	dev-java/bsh:0
	dev-java/junit:0
	dev-util/checkstyle:0"
DEPEND="${RDEPEND}
	dev-java/ant-contrib:0"

S="${WORKDIR}/jdee-${PV}"
SITEFILE="70${PN}-gentoo.el"

pkg_setup() {
	java-pkg-2_pkg_setup
	elisp_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.4.0.1-fix-paths-gentoo.patch"
	epatch "${FILESDIR}/${PN}-2.4.0.1-classpath-gentoo.patch"
	epatch "${FILESDIR}/${PN}-2.4.1-doc-directory.patch"

	local bshjar csjar
	bshjar=$(java-pkg_getjar --build-only bsh bsh.jar) || die
	csjar=$(java-pkg_getjar --build-only checkstyle checkstyle.jar) || die
	sed -e "s:@BSH_JAR@:${bshjar}:;s:@CHECKSTYLE_JAR@:${csjar}:" \
		-e "s:@PF@:${PF}:" "${FILESDIR}/${SITEFILE}" >"${SITEFILE}" || die

	cd java/lib || die
	java-pkg_jar-from --build-only checkstyle checkstyle.jar checkstyle-all.jar
	java-pkg_jar-from junit
	java-pkg_jar-from bsh
}

src_compile() {
	ANT_TASKS="ant-contrib" \
		eant -Delib.dir="${EPREFIX}${SITELISP}/elib" \
		bindist $(usex doc source-doc "")
}

src_install() {
	local dist="dist/jdee-${PV%_*}"

	java-pkg_dojar ${dist}/java/lib/jde.jar
	insinto "${JAVA_PKG_SHAREPATH}"
	doins -r java/bsh-commands

	use source && java-pkg_dosrc java/src/*
	use doc && java-pkg_dojavadoc ${dist}/doc/java/api

	elisp-install ${PN} ${dist}/lisp/*.{el,elc}
	elisp-site-file-install "${SITEFILE}"

	dobin ${dist}/lisp/jtags

	dohtml -r doc/html/*
}
