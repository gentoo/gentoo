# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/cksfv/cksfv-1.3.14.ebuild,v 1.4 2014/06/06 05:17:54 vapier Exp $

EAPI="4"

inherit toolchain-funcs

DESCRIPTION="SFV checksum utility (simple file verification)"
HOMEPAGE="http://zakalwe.fi/~shd/foss/cksfv/"
SRC_URI="http://zakalwe.fi/~shd/foss/cksfv/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux"
IUSE=""

src_configure() {
	# note: not an autoconf configure script
	./configure \
		--compiler="$(tc-getCC)" \
		--prefix="${EPREFIX}"/usr \
		--package-prefix="${D}" \
		--bindir="${EPREFIX}"/usr/bin \
		--mandir="${EPREFIX}"/usr/share/man || die
}

src_install() {
	emake install
	dodoc ChangeLog README TODO
}
