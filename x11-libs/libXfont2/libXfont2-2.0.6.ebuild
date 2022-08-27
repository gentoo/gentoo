# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_DOC=doc
XORG_PACKAGE_NAME=libxfont
XORG_TARBALL_SUFFIX="xz"
inherit xorg-3

DESCRIPTION="X.Org Xfont library"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="bzip2 truetype"

RDEPEND="sys-libs/zlib
	dev-libs/libbsd
	x11-libs/libfontenc
	bzip2? ( app-arch/bzip2 )
	truetype? ( >=media-libs/freetype-2 )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-libs/xtrans"

src_configure() {
	local XORG_CONFIGURE_OPTIONS=(
		--enable-ipv6
		$(use_enable doc devel-docs)
		$(use_with doc xmlto)
		$(use_with bzip2)
		$(use_enable truetype freetype)
		--without-fop
	)
	xorg-3_src_configure
}
