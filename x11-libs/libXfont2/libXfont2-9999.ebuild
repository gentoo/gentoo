# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

XORG_PACKAGE_NAME=libxfont
XORG_DOC=doc
inherit xorg-3

DESCRIPTION="X.Org Xfont library"

KEYWORDS=""
IUSE="bzip2 ipv6 truetype"

RDEPEND="sys-libs/zlib
	x11-base/xorg-proto
	x11-libs/libfontenc
	bzip2? ( app-arch/bzip2 )
	truetype? ( >=media-libs/freetype-2 )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-libs/xtrans"

pkg_setup() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable ipv6)
		$(use_enable doc devel-docs)
		$(use_with doc xmlto)
		$(use_with bzip2)
		$(use_enable truetype freetype)
		--without-fop
	)
}
