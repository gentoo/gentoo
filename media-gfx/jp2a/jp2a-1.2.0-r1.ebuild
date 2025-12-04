# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="JPEG/PNG image to ASCII art converter"
HOMEPAGE="https://github.com/Talinx/jp2a/"
SRC_URI="https://github.com/Talinx/jp2a/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="curl"

RDEPEND="media-libs/libjpeg-turbo:=
	media-libs/libpng
	curl? ( net-misc/curl )
	sys-libs/ncurses:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.3.2-tinfo.patch"
)

src_configure() {
	econf $(use_enable curl)
}

src_prepare() {
	default

	eautoreconf
}
