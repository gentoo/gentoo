# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

DESCRIPTION="WAD composer for Doom, Heretic, Hexen, and Strife"
HOMEPAGE="https://github.com/Doom-Utils/deutex"
SRC_URI="https://github.com/Doom-Utils/${PN}/releases/download/v${PV}/${P}.tar.zst"

LICENSE="GPL-2+ LGPL-2+ HPND"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="man +png"

DEPEND="png? ( media-libs/libpng:0= )"
RDEPEND="${DEPEND}"
BDEPEND="$(unpacker_src_uri_depends)
	man? ( app-text/asciidoc )"

src_configure() {
	econf \
		$(use_enable man) \
		$(use_with png libpng)
}
