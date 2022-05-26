# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="JPEG/PNG image to ASCII art converter"
HOMEPAGE="https://github.com/Talinx/jp2a/"
SRC_URI="https://github.com/Talinx/jp2a/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x64-macos ~x64-solaris"
IUSE="curl"

# TODO: restore ncurses support?
# See https://github.com/gentoo/gentoo/pull/24218#issuecomment-1043795319
RDEPEND="virtual/jpeg
	media-libs/libpng
	curl? ( net-misc/curl )"
DEPEND="${RDEPEND}"

src_configure() {
	econf $(use_enable curl)
}
