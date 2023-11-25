# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Native WebGPU implementation based on wgpu-core"
HOMEPAGE="https://github.com/gfx-rs/wgpu-native"

SRC_URI_BASE="https://github.com/gfx-rs/wgpu-native/releases/download/v${PV}/wgpu-linux-x86_64"
SRC_URI="debug? ( ${SRC_URI_BASE}-debug.zip -> ${P}.zip )
		!debug? ( ${SRC_URI_BASE}-release.zip -> ${P}.zip )"

LICENSE="Apache-2.0 MIT"
SLOT="0"

KEYWORDS="~amd64"

IUSE="debug static-libs"

RDEPEND=""
DEPEND="${RDEPEND}"
BDEPEND=""

S="${WORKDIR}"

src_install() {
	dolib.so libwgpu_native.so
	use static-libs && dolib.a libwgpu_native.a
	doheader webgpu.h wgpu.h
}
