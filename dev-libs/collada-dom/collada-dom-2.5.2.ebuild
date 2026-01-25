# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gepetto/collada-dom"
else
	SRC_URI="https://github.com/gepetto/collada-dom/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
fi

DESCRIPTION="COLLADA Document Object Model (DOM) C++ Library"
HOMEPAGE="https://github.com/gepetto/collada-dom"

LICENSE="MIT"
SLOT="0/25"

RDEPEND="
	dev-libs/boost:=
	dev-libs/libxml2:=
	dev-libs/libpcre[cxx]
	virtual/minizip:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/collada-dom-2.5.0-boost-1.89.patch # bug 968458
)

src_configure() {
	# bug 618960
	append-cxxflags -std=c++14

	cmake_src_configure
}
