# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="A wrapper script to start Compiz 0.8.x with proper options"
HOMEPAGE="https://github.com/compiz-reloaded"
EGIT_REPO_URI="https://github.com/compiz-reloaded/compiz-manager.git"

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="x11-apps/mesa-progs
		x11-apps/xdpyinfo
		>=x11-wm/compiz-${PV}
"

src_install() {
	dobin compiz-manager
}
