# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Lightweight osu! port"
HOMEPAGE="https://github.com/fmang/oshu"
SRC_URI="https://www.mg0.fr/oshu/releases/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3 CC-BY-NC-4.0"
SLOT="0"
IUSE="libav"

RDEPEND="
	media-libs/libsdl2:=
	media-libs/sdl2-image:=
	x11-libs/cairo:=
	!libav? ( media-video/ffmpeg:= )
	libav? ( media-video/libav:= )
"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
