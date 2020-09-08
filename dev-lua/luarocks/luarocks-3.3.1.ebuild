# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A deployment and management system for Lua modules"
HOMEPAGE="http://www.luarocks.org"
SRC_URI="http://luarocks.org/releases/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 x86"
IUSE="libressl"

DEPEND="dev-lang/lua:="
RDEPEND="${DEPEND}
	net-misc/curl
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl:0 )
"
BDEPEND="virtual/pkgconfig"

src_configure() {
	# econf doesn't work b/c it passes variables the custom configure can't
	# handle
	./configure \
			--prefix="${EPRIFIX}/usr" \
			--with-lua-lib="${EPRIFIX}/usr/$(get_libdir)" \
			--rocks-tree="${EPRIFIX}/usr/$(get_libdir)/lua/luarocks" \
			|| die "configure failed"
}

src_install() {
	default
	{ find "${D}" -type f -exec sed -i -e "s:${D}::g" {} \;; } || die "sed failed"
}
