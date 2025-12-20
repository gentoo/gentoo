# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs autotools

DESCRIPTION="Microsoft compress.exe/expand.exe compatible (de)compressor"
HOMEPAGE="https://gnuwin32.sourceforge.net/packages/mscompress.htm"
SRC_URI="ftp://ftp.penguin.cz/pub/users/mhi/mscompress/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ppc ~ppc64 x86"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-amd64.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	tc-export CC
	# bug #148320
	append-flags -fsigned-char
	econf
}

src_install() {
	dobin mscompress msexpand
	doman mscompress.1 msexpand.1
	einstalldocs
}
