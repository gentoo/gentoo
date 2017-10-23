# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION=" Helper utilities for debugging Compiz"
HOMEPAGE="https://github.com/compiz-reloaded"
EGIT_REPO_URI="https://github.com/compiz-reloaded/compiz-debug-utils.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""

RDEPEND="
		>=dev-lang/python-3:*
		=x11-wm/compiz-${PV}[dbus]
"
DEPEND="${RDEPEND}"

src_install() {
	dodoc README.md
	rm README.md
	dobin *
}
