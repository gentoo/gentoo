# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://github.com/projg2/${PN}.git"
inherit autotools git-r3

DESCRIPTION="Convert pixel images (e.g. QRCode) to PGF/Tikz rectangles"
HOMEPAGE="https://github.com/projg2/pixels2pgf/"

LICENSE="BSD"
SLOT="0"

RDEPEND="
	media-libs/libsdl:0=
	media-libs/sdl-image:0=
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}
