# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils libtool toolchain-funcs

DESCRIPTION="BitTorrent library written in C++ for *nix"
HOMEPAGE="https://rakshasa.github.io/rtorrent/"
SRC_URI="http://rtorrent.net/downloads/${P}.tar.gz"

LICENSE="GPL-2"

# The README says that the library ABI is not yet stable and dependencies on
# the library should be an explicit, syncronized version until the library
# has had more time to mature. Until it matures we should not include a soname
# subslot.
SLOT="0"

KEYWORDS="amd64 ~arm ~hppa ~ia64 ppc ~ppc64 ~sparc x86 ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris"
IUSE="debug ipv6 libressl ssl test"

RDEPEND="
	sys-libs/zlib
	>=dev-libs/libsigc++-2.2.2:2
	ssl? (
	    !libressl? ( dev-libs/openssl:0= )
	    libressl? ( dev-libs/libressl:= )
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-util/cppunit )"

src_prepare() {
	elibtoolize
}

src_configure() {
	# configure needs bash or script bombs out on some null shift, bug #291229
	CONFIG_SHELL=${BASH} econf \
		--enable-aligned \
		$(use_enable debug) \
		$(use_enable ipv6) \
		$(use_enable ssl openssl) \
		--with-posix-fallocate
}

src_install() {
	default

	prune_libtool_files --all
}
