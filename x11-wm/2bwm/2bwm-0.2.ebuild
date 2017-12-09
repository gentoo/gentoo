# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 savedconfig

DESCRIPTION="A fast floating WM written over the XCB library and derived from mcwm"
HOMEPAGE="https://github.com/venam/2bwm"
EGIT_REPO_URI="https://github.com/venam/2bwm"
EGIT_COMMIT="6a453990a79f7b62ca057f380cf6cb616329a553"

SLOT="0"
KEYWORDS=""
IUSE="savedconfig"
LICENSE="ISC"

DEPEND="x11-libs/xcb-util
	x11-libs/xcb-util-xrm
	x11-libs/xcb-util-wm
	x11-libs/xcb-util-keysyms"
RDEPEND="${DEPEND}"

src_configure(){
	restore_config config.h
}
