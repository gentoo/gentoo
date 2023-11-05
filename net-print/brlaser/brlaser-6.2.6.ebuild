# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Brother laser printer driver"
HOMEPAGE="https://github.com/Owl-Maintain/brlaser/"
SRC_URI="https://github.com/Owl-Maintain/brlaser/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

# https://github.com/Owl-Maintain/brlaser/blob/master/src/main.cc#L5C1-L8C39
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="net-print/cups"
RDEPEND="
	${DEPEND}
	app-text/ghostscript-gpl
"

src_prepare() {
	# Don't clobber toolchain defaults
	sed -i -e '/-D_FORTIFY_SOURCE=2/d' CMakeLists.txt || die

	cmake_src_prepare
}
