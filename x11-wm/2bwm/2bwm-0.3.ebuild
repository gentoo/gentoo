# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit savedconfig toolchain-funcs

if [[ ${PV} == *9999 ]]; then
		inherit git-r3
		EGIT_REPO_URI="https://github.com/venam/2bwm.git"
else
		SRC_URI="https://github.com/venam/2bwm/archive/v${PV}.tar.gz -> ${P}.tar.gz"
		KEYWORDS="~amd64"
fi

DESCRIPTION="A fast, floating window manager"
HOMEPAGE="https://github.com/venam/2bwm"

LICENSE="ISC"
SLOT="0"

DEPEND="
	x11-libs/libxcb
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-wm
	x11-libs/xcb-util-xrm
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i -e "s:-Os -s::" Makefile || die
	restore_config config.h
}

src_compile() {
	emake CC="$(tc-getCC)" all
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	dodoc README.md
	save_config config.h
}
