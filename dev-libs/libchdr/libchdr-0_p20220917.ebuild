# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

HASH_CHDR=e02b3d68eb759793ab8142376594c840c1194b3e

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
