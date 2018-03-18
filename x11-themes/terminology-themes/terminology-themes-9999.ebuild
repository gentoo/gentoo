# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 xdg-utils

DESCRIPTION="Color schemes for the Terminology terminal emulator"
HOMEPAGE="https://charlesmilette.net/terminology-themes/"
SRC_URI=""

EGIT_REPO_URI="https://github.com/sylveon/terminology-themes"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-libs/efl"
RDEPEND="x11-terms/terminology"

src_prepare() {
	default
	xdg_environment_reset
}

src_compile() {
	emake -j1
}
