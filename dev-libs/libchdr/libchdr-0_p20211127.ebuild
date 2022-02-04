# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

CHDR_COMMIT="929a8d6523a7d21ea9e035f43211cd759e072053"

DESCRIPTION="Standalone library for reading MAME's CHDv1-v5 formats"
HOMEPAGE="https://github.com/rtissera/libchdr/"
SRC_URI="https://github.com/rtissera/libchdr/archive/${CHDR_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${CHDR_COMMIT}"

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
