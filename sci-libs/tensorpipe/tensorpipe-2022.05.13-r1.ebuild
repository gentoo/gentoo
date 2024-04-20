# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

CommitId=bb1473a4b38b18268e8693044afdb8635bc8351b

DESCRIPTION="provides a tensor-aware channel"
HOMEPAGE="https://github.com/pytorch/tensorpipe/"
SRC_URI="https://github.com/pytorch/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda"
RESTRICT=test

RDEPEND="
	dev-libs/libuv
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
	)
"
DEPEND="${RDEPEND}
	dev-libs/libnop
"

S="${WORKDIR}"/${PN}-${CommitId}

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-musl.patch
)

src_configure() {
	local mycmakeargs=(
		-DTP_USE_CUDA=$(usex cuda)
	)
	cmake_src_configure
}
