# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="A curses-based tool for viewing and analyzing log files"
HOMEPAGE="https://lnav.org"
SRC_URI="https://github.com/tstack/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="pcap test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/bzip2:0=
	app-arch/libarchive:=
	>=dev-db/sqlite-3.9.0
	dev-libs/libpcre[cxx]
	>=net-misc/curl-7.23.0
	sys-libs/ncurses:=
	sys-libs/readline:=
	sys-libs/zlib:=
	pcap? ( net-analyzer/wireshark[tshark] )"
# The tests use ssh-keygen and use dsa and rsa keys (which is why ssl is required)
DEPEND="${RDEPEND}
	test? (
		net-misc/openssh[ssl]
		dev-cpp/doctest
	)"

DOCS=( AUTHORS NEWS README )

PATCHES=(
	"${FILESDIR}"/${PN}-0.11.0-disable-tests.patch
	# https://github.com/tstack/lnav/pull/1041
	"${FILESDIR}"/${PN}-0.11.0-conditional-ssh-keygen.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	filter-lto

	econf \
		--disable-static \
		--with-ncurses \
		$(use_with test system-doctest)
}
