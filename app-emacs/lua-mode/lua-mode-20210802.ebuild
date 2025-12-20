# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="An Emacs major mode for editing Lua scripts"
HOMEPAGE="http://lua-users.org/wiki/LuaEditorSupport
	http://immerrr.github.io/lua-mode/"
SRC_URI="https://github.com/immerrr/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~sparc x86"
RESTRICT="test"		# tests require cask which isn't packaged yet

SITEFILE="50${PN}-gentoo.el"
DOCS="NEWS README README.md TODO"
