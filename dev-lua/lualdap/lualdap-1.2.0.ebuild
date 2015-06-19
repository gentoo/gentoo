# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lua/lualdap/lualdap-1.2.0.ebuild,v 1.2 2015/03/10 13:33:22 zx2c4 Exp $

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

RDEPEND="dev-lang/lua:*"
DEPEND="${RDEPEND}
	net-nds/openldap
	virtual/pkgconfig"
