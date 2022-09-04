# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A curses-based tool for viewing and analyzing log files"
HOMEPAGE="https://lnav.org"
SRC_URI="https://github.com/tstack/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pcap test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/bzip2:0=
	app-arch/libarchive:=
	>=dev-db/sqlite-3.9.0
	dev-libs/libpcre[cxx]
	>=net-misc/curl-7.23.0
	sys-libs/ncurses:=
	sys-libs/readline:0=
	sys-libs/zlib:0=
	pcap? ( net-analyzer/wireshark[tshark] )"
# Once we fix https://bugs.gentoo.org/show_bug.cgi?id=813444, we can change net-misc/openssh to be
# conditional on the test USE flag. Unfortunately, for now lnav runs some test code unconditionally
# that uses ssh-keygen, so that's why we unconditionally depend on it at the moment.
DEPEND="${RDEPEND}
	net-misc/openssh[ssl]
	test? ( dev-cpp/doctest )"

DOCS=( AUTHORS NEWS README )

PATCHES=(
	"${FILESDIR}"/${PN}-0.11.0-disable-tests.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--with-ncurses \
		$(use_with test system-doctest)
}
