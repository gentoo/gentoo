# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="The Linux Security Auditing Tool"
HOMEPAGE="http://usat.sourceforge.net/"
SRC_URI="http://usat.sourceforge.net/code/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="minimal"

DEPEND="dev-lang/perl" # pod2man
RDEPEND="!minimal? (
		app-portage/portage-utils
		net-analyzer/nmap
		sys-apps/iproute2
		sys-apps/which
		sys-process/lsof
	)"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gentoo.patch

	# patch for segmentation fault see bug #184488
	epatch "${FILESDIR}"/${P}-segfault-fix.patch
	sed -i Makefile.in \
		-e '/^LDFLAGS=/d' \
		-e '/^CFLAGS=/d' \
		|| die "sed Makefile.in"
}

src_compile() {
	tc-export CC
	econf
	emake CFLAGS="${CFLAGS}" all manpage || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install installman || die "emake install failed"
	dodoc README* *.txt
	dohtml modules.html changelog/changelog.html
}
