# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="SFV checksum utility (simple file verification)"
HOMEPAGE="http://zakalwe.fi/~shd/foss/cksfv/"
SRC_URI="http://zakalwe.fi/~shd/foss/cksfv/files/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ~sparc x86 ~amd64-linux ~x86-linux"

src_configure() {
	# note: not an autoconf configure script
	./configure \
		--compiler="$(tc-getCC)" \
		--prefix="${EPREFIX}"/usr \
		--package-prefix="${D}" \
		--bindir="${EPREFIX}"/usr/bin \
		--mandir="${EPREFIX}"/usr/share/man || die
}
