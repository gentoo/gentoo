# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="BitTorrent library written in C++ for *nix"
HOMEPAGE="https://rtorrent.net"
if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rakshasa/${PN}.git"
else
	SRC_URI="https://github.com/rakshasa/rtorrent/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x64-macos ~x64-solaris"
fi

LICENSE="GPL-2"
# The README says that the library ABI is not yet stable and dependencies on
# the library should be an explicit, syncronized version until the library
# has had more time to mature. Until it matures we should not include a soname
# subslot.
SLOT="0"
IUSE="debug test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/openssl:=
	net-libs/udns
	net-misc/curl
	virtual/zlib:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( dev-util/cppunit )
"

src_prepare() {
	default

	# use system-udns
	rm -r src/net/udns || die
	sed -e 's@"net/udns/udns.h"@<udns.h>@' \
		-e '\@^#include "net/udns/udns_.*.c"@d' \
		-i src/net/udns_library.cc src/net/udns_library.h src/net/udns_resolver.cc || die

	if [[ ${CHOST} != *-darwin* ]]; then
		# syslibroot is only for macos, change to sysroot for others
		sed -i 's/Wl,-syslibroot,/Wl,--sysroot,/' "${S}/scripts/common.m4" || die
	fi
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		LIBS="-ludns"
		--enable-aligned
		$(use_enable debug)
		--with-posix-fallocate
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -type f -name '*.la' -delete || die
}
