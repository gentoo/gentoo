# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Commandline utility to convert ID3 tags in mp3 files between different encodings"
HOMEPAGE="https://mp3unicode.sourceforge.net"
HOMEPAGE+=" https://github.com/alonbl/mp3unicode"
SRC_URI="https://github.com/alonbl/${PN}/releases/download/${P}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="media-libs/taglib:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-fix-build-taglib2.patch )
