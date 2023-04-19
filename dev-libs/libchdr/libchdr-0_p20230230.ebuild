# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

HASH_CHDR=fec8ab94212cc65d9d9a62cb3da924f5830c04b0

DESCRIPTION="Standalone library for reading MAME's CHDv1-v5 formats"
HOMEPAGE="https://github.com/rtissera/libchdr/"
SRC_URI="https://github.com/rtissera/libchdr/archive/${HASH_CHDR}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${HASH_CHDR}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-libs/zlib:="
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DWITH_SYSTEM_ZLIB=yes
	)

	cmake_src_configure
}
