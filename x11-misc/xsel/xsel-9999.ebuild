# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools git-r3

DESCRIPTION="Command-line program for getting and setting the contents of the X selection"
HOMEPAGE="http://www.vergenet.net/~conrad/software/xsel"
EGIT_REPO_URI="https://github.com/kfish/xsel"

LICENSE="HPND"
SLOT="0"
KEYWORDS=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
	x11-libs/libXt
"

src_prepare() {
	sed -i -e 's| -Werror -g||g' configure.ac || die
	default
	eautoreconf
}
