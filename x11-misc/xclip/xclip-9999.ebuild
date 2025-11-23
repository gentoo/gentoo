# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools git-r3

DESCRIPTION="Copy data from standard input to X clipboard"
HOMEPAGE="https://github.com/astrand/xclip"
EGIT_REPO_URI="https://github.com/astrand/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXmu
"

DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
	x11-libs/libXt
"

src_prepare() {
	default
	eautoreconf
}
