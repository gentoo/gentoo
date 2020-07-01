# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2

DESCRIPTION="JLex: a lexical analyzer generator for Java"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
HOMEPAGE="https://www.cs.princeton.edu/~appel/modern/java/JLex/"

KEYWORDS="amd64 x86"
LICENSE="jlex"
SLOT="0"
IUSE=""

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6
	source? ( app-arch/zip )"

src_compile() {
	ejavac -nowarn Main.java
}

src_install() {
	dodoc README Bugs

	if use doc; then
		dohtml manual.html
		dodoc sample.lex
	fi

	mkdir JLex || die
	mv *.class JLex/ || die
	jar cf jlex.jar JLex/ || die "failed to jar"

	java-pkg_dojar "${PN}.jar"
	java-pkg_dolauncher "${PN}" --main JLex.Main "${PN}.jar"

	if use source; then
		rm JLex/*
		cp Main.java JLex
		java-pkg_dosrc JLex
	fi
}
