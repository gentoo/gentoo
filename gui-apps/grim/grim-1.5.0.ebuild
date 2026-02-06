# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit shell-completion meson

DESCRIPTION="Grab images from a Wayland compositor"
HOMEPAGE="https://gitlab.freedesktop.org/emersion/grim"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/emersion/grim.git"
else
	inherit verify-sig
	SRC_URI="https://gitlab.freedesktop.org/emersion/grim/-/releases/v${PV}/downloads/${P}.tar.gz
		https://gitlab.freedesktop.org/emersion/grim/-/releases/v${PV}/downloads/${P}.tar.gz.sig"
	KEYWORDS="amd64 arm64 ~loong ppc64 ~riscv x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+man jpeg"

RDEPEND="
	dev-libs/wayland
	media-libs/libpng
	x11-libs/pixman
	jpeg? ( media-libs/libjpeg-turbo )
"
DEPEND="${RDEPEND}
	>=dev-libs/wayland-protocols-1.14
"
BDEPEND="
	dev-util/wayland-scanner
	man? ( app-text/scdoc )
"

if [[ ${PV} != 9999 ]]; then
	BDEPEND+=" verify-sig? ( sec-keys/openpgp-keys-emersion )"
	VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/emersion.asc"
fi

src_configure() {
	local emesonargs=(
		$(meson_feature jpeg)
		$(meson_feature man man-pages)
		"-Dbash-completions=false"
		"-Dfish-completions=false"
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	newbashcomp contrib/completions/bash/grim.bash grim
	dofishcomp contrib/completions/fish/grim.fish
}
