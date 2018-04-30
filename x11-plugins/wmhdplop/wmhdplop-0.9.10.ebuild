# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="a dockapp for monitoring disk activities with fancy visuals"
HOMEPAGE="https://www.dockapps.net/wmhdplop"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="media-libs/imlib2[X]
	x11-libs/libX11
	x11-libs/libXext
	media-fonts/corefonts
	>=media-libs/freetype-2"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.9-64bit.patch
	"${FILESDIR}"/${P}-cflags.patch
	"${FILESDIR}"/${P}-sysmacros.patch
	)
DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	eautoreconf
	default
}

src_configure() {
	econf --disable-gkrellm
}
