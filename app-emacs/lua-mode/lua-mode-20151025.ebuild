# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="An Emacs major mode for editing Lua scripts"
HOMEPAGE="http://lua-users.org/wiki/LuaEditorSupport
	http://immerrr.github.io/lua-mode/"
SRC_URI="https://github.com/immerrr/${PN}/archive/rel-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux"
RESTRICT="test"		# tests require cask which isn't packaged yet

S="${WORKDIR}/${PN}-rel-${PV}"
SITEFILE="50${PN}-gentoo.el"
DOCS="NEWS README README.md TODO"
