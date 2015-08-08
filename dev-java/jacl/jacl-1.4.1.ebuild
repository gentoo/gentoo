# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit base java-pkg-2

DESCRIPTION="Jacl is an implementation of Tcl written in Java"
HOMEPAGE="http://tcljava.sourceforge.net"
MY_P="${P//-}"
SRC_URI="mirror://sourceforge/tcljava/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"
IUSE="doc"

RDEPEND=">=dev-lang/tcl-8.4.5
	>=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	${RDEPEND}"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}/${P}-build.patch" )

# jikes support disabled for now.
# refer to bug #100020 and bug #89711

src_compile() {
	local jflags="$(java-pkg_javac-args)"
	JAVAC_FLAGS="${jflags}" \
		econf --enable-jacl --without-jikes || die
	#ali_bush: Fails intermitently with MAKEOPTS="-j3"
	JAVAC_FLAGS="${jflags}" \
		emake -j1 DESTDIR="/usr/share/${PN}" || die "emake failed"
}

RESTRICT="test"
# Dies with anything else besides 1.4 so more trouble than benefit
src_test() {
	emake check || die "Tests failed"
	einfo "Some tests are known to fail. We didn't restrict them"
	einfo "because the ebuild doesn't die."
}

src_install() {
	#emake DESTDIR="${D}" install || die "emake install failed"
	java-pkg_dojar *.jar
	java-pkg_dolauncher jaclsh --main tcl.lang.Shell
	dodoc README ChangeLog known_issues.txt || die
	use doc && java-pkg_dohtml -r docs/*
}
