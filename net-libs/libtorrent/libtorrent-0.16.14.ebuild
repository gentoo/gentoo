# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit autotools

DESCRIPTION="BitTorrent library written in C++ for *nix"
HOMEPAGE="https://rtorrent.net"
if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rakshasa/${PN}.git"
else
	SRC_URI="https://github.com/rakshasa/rtorrent/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos ~x64-solaris"
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
DEPEND="${RDEPEND}
	test? ( dev-util/cppunit )
"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# use system-udns
	rm -r src/net/udns || die
	sed -e 's@"net/udns/udns.h"@<udns.h>@' \
		-e '\@^#include "net/udns/udns_.*.c"@d' \
		-i src/net/udns_library.cc src/net/udns_library.h src/net/udns_resolver.cc || die

	[[ ${PV} == *9999 ]] && eautoreconf
}

src_configure() {
	local myeconfargs=(
		LIBS="-ludns"
		$(use_enable debug)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -type f -name '*.la' -delete || die
}
