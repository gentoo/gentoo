# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 meson

DESCRIPTION="Grab images from a Wayland compositor"
HOMEPAGE="https://sr.ht/~emersion/grim"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.sr.ht/~emersion/${PN}"
else
	SRC_URI="https://github.com/emersion/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
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
BDEPEND="man? ( app-text/scdoc )"

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
	insinto /usr/share/fish/vendor_completions.d/
	doins contrib/completions/fish/grim.fish
}
