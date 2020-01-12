# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils multilib

DESCRIPTION="A deployment and management system for Lua modules"
HOMEPAGE="http://www.luarocks.org"
SRC_URI="http://luarocks.org/releases/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="dev-lang/lua:0"
RDEPEND="${DEPEND}
		app-arch/unzip"

src_configure() {
	# econf doesn't work b/c it passes variables the custom configure can't
	# handle
	./configure \
		--prefix=/usr \
		--with-lua-lib=/usr/$(get_libdir) \
		--rocks-tree=/usr/$(get_libdir)/lua/luarocks \
		--sysconfdir=/etc \
		|| die "configure failed"
}

pkg_preinst() {
	find "${D}" -type f | xargs sed -i -e "s:${D}::g" || die "sed failed"
}
