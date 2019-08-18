# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1 toolchain-funcs

DESCRIPTION="Embedded language which can be used as a macro preprocessor"
HOMEPAGE="http://cook.sourceforge.net/"
SRC_URI="mirror://sourceforge/cook/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86 ~x86-linux ~ppc-macos ~sparc-solaris"

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	newbin src/cook cookproc

	dodoc README doc/cook.txt doc/cook.html
	docinto examples
	dodoc test/pcb.dbdef test/pcb.dg test/pcbprol.ps test/tempsens.pcb
	docompress -x /usr/share/doc/${PF}/examples

	local DOC_CONTENTS="
	NOTICE:
	${EPREFIX}/usr/bin/cook has been renamed to ${EPREFIX}/usr/bin/cookproc in Gentoo
	-- Karl Trygve Kalleberg <karltk@gentoo.org>"
	readme.gentoo_create_doc
	dodoc "${T}"/README.gentoo
}

pkg_postinst() {
	readme.gentoo_print_elog
}
