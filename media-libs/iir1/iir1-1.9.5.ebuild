# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

DESCRIPTION="DSP IIR realtime filter library written in C++"
HOMEPAGE="https://github.com/berndporr/iir1"
SRC_URI="https://github.com/berndporr/iir1/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

src_configure() {
	local mycmakeargs=(
		-DIIR1_BUILD_DEMO=no
		-DIIR1_BUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
