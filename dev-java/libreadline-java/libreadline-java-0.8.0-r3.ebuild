# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=2
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 eutils

DESCRIPTION="A JNI-wrapper to GNU Readline"
HOMEPAGE="http://java-readline.sourceforge.net/"
SRC_URI="mirror://sourceforge/java-readline/${P}-src.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE="elibc_FreeBSD"

COMMON_DEP="sys-libs/ncurses"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"
RESTRICT="test"

java_prepare() {
	epatch "${FILESDIR}/termcap-to-ncurses.patch"
	# bug #157387, reported upstream
	epatch "${FILESDIR}/${P}-gmake.patch"

	# bug #157390
	sed -i "s/^\(JC_FLAGS =\)/\1 $(java-pkg_javac-args)/" Makefile || die
	if use elibc_FreeBSD; then
		sed -i -e '/JAVANATINC/s:linux:freebsd:' Makefile || die "sed JAVANATINC failed"
	fi

	#Respect CC CFLAGS LDFLAGS #336302 #296741
	epatch "${FILESDIR}"/${P}-respect-flags.patch
}

src_compile() {
	emake -j1 || die "failed to compile"
	if use doc; then
		emake -j1 apidoc || die "failed to generate docs"
	fi
}

src_install() {
	java-pkg_doso *.so
	java-pkg_dojar *.jar
	use source && java-pkg_dosrc src/*
	use doc && java-pkg_dojavadoc api
	dodoc ChangeLog NEWS README README.1st TODO || die
}
