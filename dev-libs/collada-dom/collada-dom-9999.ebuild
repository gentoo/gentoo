# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils flag-o-matic

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rdiankov/collada-dom"
else
	KEYWORDS="~amd64 ~arm"
	SRC_URI="https://github.com/rdiankov/collada-dom/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="COLLADA Document Object Model (DOM) C++ Library"
HOMEPAGE="https://github.com/rdiankov/collada-dom"

LICENSE="MIT"
SLOT="0/25"
IUSE=""

RDEPEND="
	dev-libs/boost:=
	sys-libs/zlib:=[minizip]
	dev-libs/libxml2:=
	dev-libs/libpcre:=[cxx]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	# bug 618960
	append-cxxflags -std=c++14

	cmake-utils_src_configure
}
