# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Burrows-Wheeler Alignment Tool, a fast short genomic sequence aligner"
HOMEPAGE="https://github.com/lh3/bwa/"
SRC_URI="https://github.com/lh3/bwa/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"

DEPEND="sys-libs/zlib"
RDEPEND="
	${DEPEND}
	dev-lang/perl"

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.17-Makefile.patch
	"${FILESDIR}"/${PN}-0.7.17-gcc-10.patch
)
DOCS=( NEWS.md README-alt.md README.md )

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/862255
	# https://github.com/lh3/bwa/issues/411
	filter-lto

	tc-export CC AR
}

src_install() {
	dobin bwa

	exeinto /usr/libexec/${PN}
	doexe qualfa2fq.pl xa2multi.pl

	einstalldocs
	doman bwa.1
}
