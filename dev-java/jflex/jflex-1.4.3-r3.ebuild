# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# Currently, this package uses an included JFlex.jar file to bootstrap.
# Upstream was contacted and this bootstrap is really needed. The only way to avoid it would be to use a supplied pre-compiled .scanner file.

EAPI="5"

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="JFlex is a lexical analyzer generator for Java"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.jflex.de/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-fbsd ~ppc-macos ~x64-macos ~x86-macos"

CDEPEND="dev-java/junit:0
	dev-java/javacup:0
	dev-java/ant-core:0"

#RDEPEND=">=virtual/jre-1.6
RDEPEND=">=virtual/jre-1.6
	vim-syntax? (
		|| (
			app-editors/vim app-editors/gvim
		)
	)
	${CDEPEND}"

#DEPEND=">=virtual/jdk-1.6
DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"

IUSE="doc source vim-syntax"

src_unpack() {
	unpack "${P}.tar.gz"
	cd "${S}/src" || die

	mkdir "${S}/tools" || die

	cp "${S}/lib/JFlex.jar" "${S}/tools/JFlex.jar" || die
	rm -rf java_cup "${S}/lib/JFlex.jar" || die

	java-ant_rewrite-classpath
}

src_compile() {
	ANT_TASKS="javacup"
	local jflex_cp="$(java-pkg_getjars --build-only junit):$(java-pkg_getjars ant-core,javacup)"
	cd "${S}/src" || die
	eant realclean || die
	eant -Dgentoo.classpath="${jflex_cp}" jar || die

	rm "${S}/tools/JFlex.jar" || die
	cp "${S}/lib/JFlex.jar" "${S}/tools/" || die
	rm "${S}/lib/JFlex.jar" || die

	eant realclean || die
	einfo "Recompiling using the newly generated JFlex library" || die
	eant -Dgentoo.classpath="${jflex_cp}" jar || die
}

src_install() {
	java-pkg_dojar lib/JFlex.jar
	java-pkg_dolauncher "${PN}" --main JFlex.Main
	java-pkg_register-ant-task

	dodoc doc/manual.pdf doc/manual.ps.gz src/changelog
	dohtml -r doc/*

	use source && java-pkg_dosrc src/JFlex

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins "${S}/lib/jflex.vim"
	fi
}
