# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Multi-platform class and template library"
HOMEPAGE="https://www.synfig.org"
SRC_URI="https://github.com/synfig/synfig/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RDEPEND=">=dev-cpp/glibmm-2.24.2:2"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i -e 's/CXXFLAGS="`echo $CXXFLAGS | sed s:-g::` $debug_flags"//' \
		-e 's/CFLAGS="`echo $CFLAGS | sed s:-g::` $debug_flags"//'     \
		m4/subs.m4 || die
	sed -i -e 's/hermite<angle>/etl::&/' test/angle.cpp

	eautoreconf
}
