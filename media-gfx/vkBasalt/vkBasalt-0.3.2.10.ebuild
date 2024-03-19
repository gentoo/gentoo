# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="A Vulkan post-processing layer for Linux"
HOMEPAGE="https://github.com/DadSchoorse/vkBasalt"
SRC_URI="https://github.com/DadSchoorse/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	dev-util/spirv-headers
	dev-util/vulkan-headers"
BDEPEND="dev-util/glslang
	virtual/pkgconfig"
