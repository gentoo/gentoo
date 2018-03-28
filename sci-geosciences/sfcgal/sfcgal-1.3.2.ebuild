# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils flag-o-matic

MY_P=SFCGAL-${PV}

DESCRIPTION="C++ library for geometric algorithms and data structures"
HOMEPAGE="http://www.sfcgal.org/"
SRC_URI="https://github.com/Oslandia/SFCGAL/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-libs/boost:=
	dev-libs/mpfr:0=
	~sci-mathematics/cgal-4.10.1[gmp]" # https://github.com/Oslandia/SFCGAL/issues/145
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_configure() {
	# use C++11 threads instead of boost::thread
	append-cxxflags -std=c++11
	cmake-utils_src_configure
}
