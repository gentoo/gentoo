# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

MY_PN="LuaLDAP"

DESCRIPTION="Simple interface from Lua to OpenLDAP"
HOMEPAGE="http://git.zx2c4.com/lualdap/about/"
SRC_URI="http://git.zx2c4.com/${PN}/snapshot/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND="dev-lang/lua:* net-nds/openldap"
DEPEND="${RDEPEND}
	net-nds/openldap
	virtual/pkgconfig"
