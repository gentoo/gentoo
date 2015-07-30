# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lua/luajson/luajson-1.3.3.ebuild,v 1.4 2015/07/30 15:07:10 ago Exp $

EAPI=5

DESCRIPTION="JSON Parser/Constructor for Lua"
HOMEPAGE="http://www.eharning.us/wiki/luajson/"
SRC_URI="https://github.com/harningt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~mips ppc ppc64 sparc ~x86"
IUSE="test"

RDEPEND="|| ( >=dev-lang/lua-5.1 dev-lang/luajit:2 )
	dev-lua/lpeg"
DEPEND="test? ( dev-lua/luafilesystem )"

# lunit not in the tree yet
RESTRICT="test"

# nothing to compile
src_compile() { :; }

src_install() {
	emake PREFIX=/usr DESTDIR="${D}" install
	dodoc README docs/ReleaseNotes-${PV}.txt docs/LuaJSON.txt
}
