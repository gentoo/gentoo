# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Dead simple tool to sign files and verify signatures"
HOMEPAGE="https://github.com/jedisct1/minisign/"
SRC_URI="
	https://github.com/jedisct1/minisign/archive/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

DEPEND="
	dev-libs/libsodium:=[-minimal(-)]
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_STRIP=OFF
	)
	cmake_src_configure
}
