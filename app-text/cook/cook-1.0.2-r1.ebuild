# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="Embedded language which can be used as a macro preprocessor and for similar text processing"
HOMEPAGE="http://cook.sourceforge.net/"
SRC_URI="mirror://sourceforge/cook/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86 ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE=""

DEPEND=""

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" || die "emake failed"
}

src_install() {
	use prefix || EPREFIX=

	dodoc README doc/cook.txt doc/cook.html || die "dodoc failed"

	insinto /usr/share/doc/${PF}/example
	doins test/pcb.dbdef test/pcb.dg test/pcbprol.ps test/tempsens.pcb || die "doins failed"

	newbin src/cook cookproc || die "newbin failed"

	cat > "${T}"/README.Gentoo <<EOF
NOTICE:

 ${EPREFIX}/usr/bin/cook has been renamed to ${EPREFIX}/usr/bin/cookproc in Gentoo

 -- Karl Trygve Kalleberg <karltk@gentoo.org>
EOF
	dodoc "${T}"/README.Gentoo || die "dodoc failed"
}

pkg_postinst() {
	ewarn "${EPREFIX}/usr/bin/cook has been renamed to ${EPREFIX}/usr/bin/cookproc"
}
