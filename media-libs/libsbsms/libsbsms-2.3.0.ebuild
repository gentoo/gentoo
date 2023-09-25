# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A library for high quality time and pitch scale modification"
HOMEPAGE="https://github.com/claytonotey/libsbsms https://sbsms.sourceforge.net/"
SRC_URI="https://github.com/claytonotey/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~mips ppc ppc64 ~riscv x86"
IUSE="cpu_flags_x86_sse static-libs"

PATCHES=( "${FILESDIR}/${PN}-2.0.2-cflags.patch" )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		$(use_enable static-libs static) \
		$(use_enable cpu_flags_x86_sse sse) \
		--disable-multithreaded
		# threaded version causes segfaults
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
