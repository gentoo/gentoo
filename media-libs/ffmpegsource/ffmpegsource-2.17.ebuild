# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/ffmpegsource/ffmpegsource-2.17.ebuild,v 1.5 2012/11/08 11:31:35 aballier Exp $

EAPI=4

AUTOTOOLS_AUTORECONF=1

inherit autotools-utils

MY_P="ffms-${PV}-src"
DESCRIPTION="An FFmpeg based source library for easy frame accurate access"
HOMEPAGE="https://code.google.com/p/ffmpegsource/"
SRC_URI="https://ffmpegsource.googlecode.com/files/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

RDEPEND="
	sys-libs/zlib
	>=virtual/ffmpeg-0.9
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}/${P}-ffmpeg.patch" )

src_configure() {
	local myeconfargs=(
		--docdir="${EPREFIX}/usr/share/doc/${PF}/html"
	)

	autotools-utils_src_configure
}
