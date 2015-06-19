# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jacl/jacl-1.3.3.ebuild,v 1.11 2014/08/10 20:15:43 slyfox Exp $

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

PATCHES=( "${FILESDIR}"/1.3.3-javacflags.patch )

# jikes support disabled for now.
# refer to bug #100020 and bug #89711

src_compile() {
	local jflags="$(java-pkg_javac-args)"
	JAVAC_FLAGS="${jflags}" \
		econf --enable-jacl --without-jikes || die
	JAVAC_FLAGS="${jflags}" \
		emake DESTDIR="/usr/share/${PN}" || die "emake failed"
}

src_test() {
	emake check || die "Tests failed"
	einfo "Some tests are known to fail. We didn't restrict them"
	einfo "because the ebuild doesn't die."
}

src_install() {
	#emake DESTDIR="${D}" install || die "emake install failed"
	java-pkg_dojar *.jar
	java-pkg_dolauncher jaclsh --main tcl.lang.Shell
	dodoc README ChangeLog known_issues.txt new_features.txt || die
	use doc && java-pkg_dohtml -r docs/*
}
