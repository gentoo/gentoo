# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 eutils java-ant-2

MY_PV=${PV/_beta/b}
MY_DIST=${PN}-${MY_PV}-src.jar

DESCRIPTION="BeanShell: A small embeddable Java source interpreter"
HOMEPAGE="http://www.beanshell.org"
SRC_URI="http://www.beanshell.org/${MY_DIST} mirror://gentoo/beanshell-icon.png"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE="bsf readline"
# some tests fail but ant doesn't fail
RESTRICT="test"

RDEPEND=">=virtual/jdk-1.4
	java-virtuals/servlet-api:3.0
	readline? ( dev-java/libreadline-java:0 )"
DEPEND="${RDEPEND}
	bsf? ( dev-java/bsf:2.3 )"

S=${WORKDIR}/BeanShell-${MY_PV}

src_unpack() {
	jar xf "${DISTDIR}"/${MY_DIST} || die "failed to unpack"
}

java_prepare() {
	find "${WORKDIR}" -name '*.jar' -delete || die

	epatch "${FILESDIR}/bsh${MY_PV}-build.patch"
	use readline && epatch "${FILESDIR}/bsh2-readline.patch"

	java-pkg_jar-from --into lib servlet-api-3.0
	use readline && java-pkg_jar-from --into lib libreadline-java
	use bsf && java-pkg_jar-from --into lib --build-only bsf-2.3
}

src_compile() {
	eant $(use bsf && echo -Dexclude-bsf=) jarall $(use_doc)
}

src_test() {
	eant test
}

src_install() {
	java-pkg_newjar dist/${P/_beta/b}.jar

	java-pkg_dolauncher bsh-console --main bsh.Console
	java-pkg_dolauncher bsh-interpreter --main bsh.Interpreter

	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc src/bsh

	newicon "${DISTDIR}"/beanshell-icon.png beanshell.png

	make_desktop_entry bsh-console "BeanShell Prompt" beanshell
}
