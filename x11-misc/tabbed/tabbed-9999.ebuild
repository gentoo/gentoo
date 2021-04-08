# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3

DESCRIPTION="Simple generic tabbed frontend to xembed-aware applications"
HOMEPAGE="https://tools.suckless.org/tabbed/"
EGIT_REPO_URI="git://git.suckless.org/tabbed"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="x11-libs/libX11"

src_prepare() {
	default
	sed config.mk -e 's#/usr/local#/usr#g'
}
