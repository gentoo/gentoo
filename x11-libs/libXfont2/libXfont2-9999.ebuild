# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

XORG_DOC=doc
EGIT_REPO_URI="https://anongit.freedesktop.org/git/xorg/lib/libXfont.git"
inherit xorg-2

DESCRIPTION="X.Org Xfont library"

KEYWORDS=""
IUSE="bzip2 ipv6 truetype"

RDEPEND="sys-libs/zlib
	x11-base/xorg-proto
	x11-libs/libfontenc
	x11-libs/xtrans
	bzip2? ( app-arch/bzip2 )
	truetype? ( >=media-libs/freetype-2 )"
DEPEND="${RDEPEND}"

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable ipv6)
		$(use_enable doc devel-docs)
		$(use_with doc xmlto)
		$(use_with bzip2)
		$(use_enable truetype freetype)
		--without-fop
	)
	xorg-2_src_configure
}
