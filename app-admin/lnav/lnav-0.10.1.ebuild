# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A curses-based tool for viewing and analyzing log files"
HOMEPAGE="https://lnav.org"
SRC_URI="https://github.com/tstack/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="unicode test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/bzip2:0=
	app-arch/libarchive:=
	>=dev-db/sqlite-3.9.0
	dev-libs/libpcre[cxx]
	>=net-misc/curl-7.23.0
	sys-libs/ncurses:=[unicode(+)?]
	sys-libs/readline:0=
	sys-libs/zlib:0="
DEPEND="${RDEPEND}
	test? ( dev-cpp/doctest )"

DOCS=( AUTHORS NEWS README )

PATCHES=(
	"${FILESDIR}"/${PN}-0.10.0-disable-tests.patch
)

src_prepare() {
	default

	eautoreconf

	# These tests use network and expect a running sshd, so we'll just delete them.
	echo "#! /bin/bash" > test/test_remote.sh || die
}

src_configure() {
	econf \
		--disable-static \
		$(use_with test system-doctest) \
		$(use_with unicode ncursesw)
}
