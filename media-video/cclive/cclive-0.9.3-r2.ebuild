# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="Command line tool for extracting videos from various websites"
HOMEPAGE="http://cclive.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PV:0:3}/${P}.tar.xz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"

RDEPEND="
	>=media-libs/libquvi-0.4.0:0=
	>=dev-cpp/glibmm-2.24:2
	>=dev-libs/boost-1.49:=
	>=dev-libs/glib-2.24:2
	>=net-misc/curl-7.20
	>=dev-libs/libpcre-8.02[cxx]"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-iostream.patch #527658
	"${FILESDIR}"/${P}-boost-ver-check.patch #548310
	"${FILESDIR}"/${P}-boost-1.67.patch #671768
)

src_configure() {
	append-cxxflags -std=c++11 #567174
	econf --disable-ccl
}
