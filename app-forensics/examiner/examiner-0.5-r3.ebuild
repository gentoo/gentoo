# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Utilizes the objdump command to disassemble and comment foreign binaries"
HOMEPAGE="http://www.academicunderground.org/examiner/"
SRC_URI="http://www.academicunderground.org/examiner/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ~x86"

RDEPEND="dev-lang/perl"

src_prepare() {
	default
	# Do not install docs through Makefile wrt bug #241256
	sed -i -e '/$(DOC)/d' Makefile || die 'sed failed'
	eapply "${FILESDIR}"/${P}-perl.patch
}

src_compile() {	:; }

src_install() {
	dodir /usr/bin /usr/share/${PN} /usr/share/man/man1

	emake \
		MAN="${D}/usr/share/man/man1" \
		BIN="${D}/usr/bin" \
		SHARE="${D}/usr/share/examiner" \
		install

	dodoc docs/{README*,BUGS,CHANGELOG,TODO,TUTORIAL}
	dodoc -r utils
}
