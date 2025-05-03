# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Really Simple replay Gain calculator for tagging audio files"
HOMEPAGE="https://github.com/complexlogic/rsgain"
SRC_URI="https://github.com/complexlogic/rsgain/releases/download/v${PV}/${P}-source.tar.xz"

LICENSE="BSD BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
        dev-libs/libfmt
        media-libs/libebur128
        media-libs/libogg
        media-libs/libvorbis
        media-libs/taglib
        media-video/ffmpeg
"

DEPEND="${RDEPEND}"

src_prepare() {
        cmake_src_prepare
}

src_configure() {
        cmake_src_configure
}

src_install() {
        cmake_src_install
}
