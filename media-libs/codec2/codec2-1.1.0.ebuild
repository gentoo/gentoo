# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="Low bit rate speech codec"
HOMEPAGE="https://freedv.org/ https://www.rowetel.com/?page_id=452 https://github.com/drowe67/codec2"
SRC_URI="https://github.com/drowe67/codec2/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/1.0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
IUSE="examples test"

# Not yet passing, but infrastructure added to run
# Needs Octave dependencies like "signal"?
# https://github.com/drowe67/codec2/commit/9a129f1b3ad12ecbf3df7f4460f496ee11e49c08#diff-b335630551682c19a781afebcf4d07bf978fb1f8ac04c6bf87428ed5106870f5R155
RESTRICT="test"

#BDEPEND="test? ( sci-mathematics/octave )"

multilib_src_configure() {
	local mycmakeargs=(
		# tries to look for octave during configure phase if unit
		# tests are turned on and bails out during configure if it
		# cannot find it.  since we have test dependency disabled
		# for now, don't flip this configure flag
		# -DUNITTEST=$(usex test) # reenable once tests wired up
		-DUNITTEST=OFF
		-DINSTALL_EXAMPLES=$(usex examples)
	)

	cmake_src_configure
}
