# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

XORG_DOC=doc
EGIT_REPO_URI="git://anongit.freedesktop.org/xorg/lib/libXfont"
inherit xorg-2

DESCRIPTION="X.Org Xfont library"

KEYWORDS=""
IUSE="bzip2 ipv6 truetype"

RDEPEND="x11-libs/xtrans
	x11-libs/libfontenc
	truetype? ( >=media-libs/freetype-2 )
	bzip2? ( app-arch/bzip2 )
	x11-proto/xproto
	>=x11-proto/fontsproto-2.1.3"
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
