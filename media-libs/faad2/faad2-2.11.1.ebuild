# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="AAC audio decoding library"
HOMEPAGE="https://www.audiocoding.com/faad2.html https://github.com/knik0/faad2/"
SRC_URI="https://github.com/knik0/faad2/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86 ~x64-macos"

# no tests
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/faad2-2.11.0-check-if-lrintf-is-defined.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
	)

	cmake-multilib_src_configure
}
