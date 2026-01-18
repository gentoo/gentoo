# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Command line tool for extracting videos from various websites"
HOMEPAGE="https://cclive.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${PV:0:3}/${P}.tar.xz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"

RDEPEND="
	>=media-libs/libquvi-0.4.0:0=
	>=dev-cpp/glibmm-2.24:2
	dev-libs/boost:=
	>=dev-libs/glib-2.24:2
	>=net-misc/curl-7.20
	>=dev-libs/libpcre-8.02[cxx]"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/xz-utils
	>=dev-build/boost-m4-0.4_p20221019-r1
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-iostream.patch #527658
	"${FILESDIR}"/${P}-boost-1.67.patch #671768
	"${FILESDIR}"/${P}-disable-silent-rules.patch
	"${FILESDIR}"/${P}-boost-1.89.patch #963410
)

src_prepare() {
	rm m4/boost.m4 || die
	default
	eautoreconf
}

src_configure() {
	append-cxxflags -std=c++11 #567174
	econf --disable-ccl
}
