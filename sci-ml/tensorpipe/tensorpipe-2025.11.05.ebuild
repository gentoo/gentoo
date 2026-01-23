# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

CommitId=2b4cd91092d335a697416b2a3cb398283246849d

DESCRIPTION="provides a tensor-aware channel"
HOMEPAGE="https://github.com/pytorch/tensorpipe/"
SRC_URI="https://github.com/pytorch/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

S="${WORKDIR}"/${PN}-${CommitId}

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

PATCHES=(
	"${FILESDIR}"/${PN}-2022.05.13-gentoo.patch
	"${FILESDIR}"/${PN}-2022.05.13-musl.patch
)

src_configure() {
	local mycmakeargs=(
		-DTP_USE_CUDA=$(usex cuda)
	)
	cmake_src_configure
}
