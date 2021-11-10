# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Combination editor, browser, and mail client that is 100% text based"
HOMEPAGE="http://edbrowse.org"
SRC_URI="https://github.com/CMB/edbrowse/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="odbc"

RDEPEND="
	>=app-text/htmltidy-5.0.0
	dev-lang/duktape:=
	dev-libs/libpcre
	net-misc/curl
	sys-libs/readline:=
	odbc? ( dev-db/unixODBC )"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/perl
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-manpage.patch
)

src_prepare() {
	cmake_src_prepare

	sed -i -e "s:/usr/share/doc/edbrowse:/usr/share/doc/${PF}:" CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_EDBR_ODBC=$(usex odbc)
	)
	cmake_src_configure
}
