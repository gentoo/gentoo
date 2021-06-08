# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 eutils

DESCRIPTION="A JNI-wrapper to GNU Readline"
HOMEPAGE="http://java-readline.sourceforge.net/"
SRC_URI="mirror://sourceforge/java-readline/${P}-src.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"
IUSE="elibc_FreeBSD"

CDEPEND="sys-libs/ncurses:0="

RDEPEND="
	>=virtual/jre-1.8:*
	${CDEPEND}"

DEPEND="
	virtual/jdk:1.8
	${CDEPEND}"

RESTRICT="test"

# 1: See bug #157387 reported upstream.
# 2: Respect CC CFLAGS LDFLAGS, see bugs #336302 #296741.
PATCHES=(
	"${FILESDIR}/termcap-to-ncurses.patch"
	"${FILESDIR}/${P}-gmake.patch"
	"${FILESDIR}/${P}-respect-flags.patch"
)

DOCS=( ChangeLog NEWS README README.1st TODO )

src_prepare() {
	default

	# See bug #157390.
	sed -i "s/^\(JC_FLAGS =\)/\1 $(java-pkg_javac-args)/" Makefile || die
	if use elibc_FreeBSD; then
		sed -i -e '/JAVANATINC/s:linux:freebsd:' Makefile || die "sed JAVANATINC failed"
	fi

}

src_compile() {
	emake -j1
	if use doc; then
		# src/org/gnu/readline/Readline.java is completely bogus and generate a
		# truckload of errors. Let's call make without catching anything. :(
		make -j1 apidoc
	fi
}

src_install() {
	java-pkg_doso *.so
	java-pkg_dojar *.jar
	use source && java-pkg_dosrc src/*
	use doc && java-pkg_dojavadoc api
}
