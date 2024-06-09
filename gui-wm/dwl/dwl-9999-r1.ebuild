# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit savedconfig toolchain-funcs

MY_P="${PN}-v${PV}"

WLROOTS_DEP="
	>=gui-libs/wlroots-0.18:=[libinput,session,X?]
	<gui-libs/wlroots-0.19:=
"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://codeberg.org/dwl/dwl.git"
	inherit git-r3

	# 9999-r0: main (latest stable wlroots release)
	# 9999-r1: wlroots-next (wlroots-9999)
	case ${PVR} in
		9999)
			EGIT_BRANCH=main
			;;
		9999-r1)
			EGIT_BRANCH=wlroots-next
			WLROOTS_DEP="~gui-libs/wlroots-9999:=[libinput,session,X?]"
			;;
	esac
else
	SRC_URI="https://codeberg.org/${PN}/${PN}/releases/download/v${PV}/${MY_P}.tar.gz"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
fi

DESCRIPTION="dwm for Wayland"
HOMEPAGE="https://codeberg.org/dwl/dwl"

LICENSE="CC0-1.0 GPL-3+ MIT"
SLOT="0"
IUSE="X"

CDEPEND="
	${WLROOTS_DEP}
	dev-libs/libinput:=
	dev-libs/wayland
	x11-libs/libxkbcommon
	X? (
		x11-libs/libxcb:=
		x11-libs/xcb-util-wm
	)
"
RDEPEND="
	${CDEPEND}
	X? (
		x11-base/xwayland
	)
"
# uses <linux/input-event-codes.h>
DEPEND="
	${CDEPEND}
	sys-kernel/linux-headers
"
BDEPEND="
	>=dev-libs/wayland-protocols-1.32
	>=dev-util/wayland-scanner-1.23
	virtual/pkgconfig
"

src_prepare() {
	restore_config config.h

	default
}

src_compile() {
	emake PKG_CONFIG="$(tc-getPKG_CONFIG)" CC="$(tc-getCC)" \
		XWAYLAND="$(usev X -DXWAYLAND)" XLIBS="$(usev X "xcb xcb-icccm")" dwl
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	dodoc CHANGELOG.md README.md

	save_config config.h
}
