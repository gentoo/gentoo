# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Dead simple tool to sign files and verify signatures"
HOMEPAGE="https://github.com/jedisct1/minisign"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jedisct1/${PN}.git"
else
	SRC_URI="https://github.com/jedisct1/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
fi

LICENSE="ISC"
SLOT="0"

IUSE=""

BDEPEND="virtual/pkgconfig"
DEPEND="dev-libs/libsodium:=[-minimal]"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=( -DCMAKE_STRIP=OFF )
	cmake_src_configure
}
