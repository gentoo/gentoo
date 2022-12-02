# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

HASH_CHDR=a20e04c12c0c20048bf771da6df7aa2e51f5e0cb

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
