# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Fork of Con Kolivas' lrzip program for compressing large files"
HOMEPAGE="https://github.com/pete4abw/lrzip-next"
SRC_URI="https://github.com/pete4abw/lrzip-next/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs year2038"

RDEPEND="app-arch/bzip2
	app-arch/bzip3
	app-arch/lz4
	app-arch/zstd
	dev-libs/lzo
	sys-libs/zlib"
DEPEND="${RDEPEND}"
BDEPEND="dev-perl/Pod-Parser
	amd64? ( dev-lang/nasm )
	x86? ( dev-lang/nasm )"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# ASM optimizations are only available on amd64 and x86
	local asm=no
	if use amd64 || use x86; then
		asm=yes
	fi

	econf \
		$(use_enable static-libs static) \
		$(use_enable year2038) \
		--enable-asm=${asm}
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
