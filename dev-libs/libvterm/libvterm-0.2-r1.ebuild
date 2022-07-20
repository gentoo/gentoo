# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="An abstract library implementation of a VT220/xterm/ECMA-48 terminal emulator"
HOMEPAGE="https://www.leonerd.org.uk/code/libvterm/"
SRC_URI="https://www.leonerd.org.uk/code/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
# Fedora have a revert patch for now:
# https://src.fedoraproject.org/rpms/libvterm/blob/rawhide/f/libvterm-0.2-fix-resize-buffer.patch
# so let's see if 0.2.1 is any better or if this is actually needed for us?
#KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86 ~x64-macos"

BDEPEND="
	dev-lang/perl
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-slibtool.patch # 779034
)

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	emake VERBOSE=1
}

src_install() {
	emake VERBOSE=1 DESTDIR="${D}" install
	find "${ED}" -name '*.la' -delete || die "Failed to prune libtool files"
}
