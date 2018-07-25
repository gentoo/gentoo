# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils

DESCRIPTION="A tool for manipulating PDF documents"
HOMEPAGE="https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/"
SRC_URI="https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/${P}-src.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86 ~amd64-linux"

RDEPEND="sys-devel/gcc:5.4.0[gcj]"
DEPEND="${RDEPEND}
	sys-devel/gcc-config
"

S="${WORKDIR}/${P}-dist/${PN}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-flags.patch
}

src_compile() {
	# Settings by java-config break compilation by gcj.
	unset CLASSPATH
	unset JAVA_HOME

	# We need gcc-5 because of Java
	export PATH="$(gcc-config -B 5.4.0):${PATH}"

	# Parallel make fails; confirmed, still not fixed in version 2.02.
	emake -j1 -f "${S}"/Makefile.Debian || die "Compilation failed."
}

src_install() {
	dobin pdftk
	doman ../pdftk.1
	dohtml ../pdftk.1.html
}
