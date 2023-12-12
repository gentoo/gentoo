# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="An abstract library implementation of a VT220/xterm/ECMA-48 terminal emulator"
HOMEPAGE="https://www.leonerd.org.uk/code/libvterm/"
SRC_URI="https://launchpad.net/libvterm/trunk/v0.3/+download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86 ~x64-macos"

BDEPEND="
	dev-lang/perl
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.3.3-slibtool.patch # 779034
)

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	emake VERBOSE=1
}

src_test() {
	emake VERBOSE=1 test
}

src_install() {
	emake VERBOSE=1 DESTDIR="${D}" install

	find "${ED}" -name '*.la' -delete || die "Failed to prune libtool files"
	find "${ED}" -name '*.a' -delete || die
}
