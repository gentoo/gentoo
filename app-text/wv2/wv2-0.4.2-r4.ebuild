# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="Excellent MS Word filter lib, used in most Office suites"
HOMEPAGE="https://wvware.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/wvware/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ppc ppc64 sparc x86"
IUSE="zlib"

RDEPEND="dev-libs/glib
	>=gnome-extra/libgsf-1.8:=
	virtual/libiconv
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-glib.patch
	"${FILESDIR}"/${P}-libgsf.patch
)

DOCS=( AUTHORS ChangeLog README RELEASE THANKS TODO )

src_configure() {
	# Due to ICU 59 requiring C++11 now
	append-cxxflags -std=c++11

	local mycmakeargs=(
		-DWITH_ZLIB=$(usex zlib)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	find "${ED}" -name '*.la' -delete || die
}
