# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

AT_M4DIR=cmulocal

inherit autotools

DESCRIPTION="Command-line MIME encoding and decoding utilities"
HOMEPAGE="ftp://ftp.andrew.cmu.edu/pub/mpack/"
SRC_URI="ftp://ftp.andrew.cmu.edu/pub/mpack/${P}.tar.gz"

SLOT="0"
LICENSE="HPND"
KEYWORDS="amd64 x86 ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE=""

PATCHES=( "${FILESDIR}"/${P}-filenames.patch
	"${FILESDIR}"/${P}-usage.patch
	"${FILESDIR}"/${P}-munpack.patch
	# NOTE: These three patches replace <mpack-1.6-gentoo.patch>
	"${FILESDIR}"/${P}-compile.patch
	"${FILESDIR}"/${P}-paths.patch
	"${FILESDIR}"/${P}-cve-2011-4919.patch

	"${FILESDIR}"/${P}-clang.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README.* Changes
}
