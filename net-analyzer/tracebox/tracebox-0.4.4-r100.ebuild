# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{2..4} )

inherit autotools flag-o-matic lua-single

DESCRIPTION="A Middlebox Detection Tool"
HOMEPAGE="http://www.tracebox.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="curl sniffer"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="test"

RDEPEND="${LUA_DEPS}
	>=net-libs/libcrafter-0.3_p20171019
	dev-libs/json-c
	net-libs/libpcap
	curl? ( net-misc/curl )
	sniffer? ( net-libs/libnetfilter_queue )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-autotools.patch
	"${FILESDIR}"/${P}-include-crafter.patch
)

src_prepare() {
	default
	# remove bundled
	# - dev-libs/json-c
	# - net-libs/libcrafter
	rm -r noinst || die
	eautoreconf
}

src_configure() {
	# https://bugs.gentoo.org/786687
	# std::byte clashes with crafter/Types.h typedef
	append-cxxflags -std=c++14

	econf \
		$(use_enable curl) \
		$(use_enable sniffer)
}
