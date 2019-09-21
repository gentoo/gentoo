# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-utils

DESCRIPTION="Combination editor, browser, and mail client that is 100% text based"
HOMEPAGE="http://edbrowse.org"
SRC_URI="https://github.com/CMB/edbrowse/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="odbc"

RDEPEND="
	app-text/tidy-html5
	>=net-misc/curl-7.36.0
	>=dev-libs/libpcre-7.8
	>=sys-libs/readline-6.0
	dev-lang/duktape
	odbc? ( dev-db/unixODBC )"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}
	dev-lang/perl
	virtual/pkgconfig"

src_prepare() {
	sed -i -e "s:/usr/share/doc/edbrowse:/usr/share/doc/${P}:" CMakeLists.txt
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_EDBR_ODBC=$(usex odbc)
	)
	cmake-utils_src_configure
}
