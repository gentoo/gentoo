# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Standalone library for reading MAME's CHDv1-v5 formats"
HOMEPAGE="https://github.com/rtissera/libchdr"
if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rtissera/${PN}.git"
else
	SRC_URI="https://github.com/rtissera/${PN}/archive/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD public-domain"
SLOT="0"

DEPEND="
	app-arch/zstd:=
	virtual/zlib:=
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DWITH_SYSTEM_ZLIB=yes
		-DWITH_SYSTEM_ZSTD=yes
	)

	cmake_src_configure
}
