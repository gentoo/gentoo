# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="compressor/uncompressor for demo recordings from id's Quake"
HOMEPAGE="https://speeddemosarchive.com/dzip/"
SRC_URI="https://speeddemosarchive.com/dzip/dz${PV/./}src.zip"
S="${WORKDIR}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${P}-system-zlib-r2.patch
	"${FILESDIR}"/${P}-scrub-names.patch #93079
	"${FILESDIR}"/dzip-amd64.diff
	"${FILESDIR}"/${PN}-clang16-build-fix.patch
)

src_prepare() {
	default

	mv -f Makefile{.linux,} || die
}

src_configure() {
	tc-export CC
}

src_install() {
	dobin dzip
	dodoc Readme
}
