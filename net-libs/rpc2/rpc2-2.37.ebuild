# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-1 )

inherit autotools flag-o-matic lua-single

DESCRIPTION="Remote procedure call package for IP/UDP (used by Coda)"
HOMEPAGE="http://www.coda.cs.cmu.edu/"
SRC_URI="https://github.com/cmusatyalab/coda/archive/refs/tags/${P}.tar.gz"
S="${WORKDIR}/coda-${P}/lib-src/rpc2"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"
IUSE="codatunneld lua"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	codatunneld? (
		dev-libs/libuv:=
		net-libs/gnutls:=
	)
	lua? (
		${LUA_DEPS}
	)
	>=sys-libs/lwp-2.5:1
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/rpc2-2.37-respect-flags.patch
	"${FILESDIR}"/rpc2-2.14-include.patch
	"${FILESDIR}"/rpc2-2.37-gcc15.patch
	"${FILESDIR}"/rpc2-2.37-lua.patch
)

src_prepare() {
	default
	eautoreconf

	# https://bugs.gentoo.org/947850
	append-cflags -std=gnu17
}

src_configure() {
	econf \
		$(use_with codatunneld libuv) \
		$(use_with lua)
}

src_install() {
	default

	find "${ED}" -type f -name '*.la' -delete || die
}
