# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature prefix

if [[ ${PV} != *9999* ]]; then
	SRC_URI="https://github.com/hykilpikonna/hyfetch/archive/refs/tags/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~x86"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hykilpikonna/hyfetch.git"
fi

DESCRIPTION="Simple information system script"
HOMEPAGE="https://github.com/hykilpikonna/hyfetch"

LICENSE="MIT-with-advertising"
SLOT="0"

src_prepare() {
	if use prefix; then
		# bug #693526
		hprefixify neofetch
		sed -e "/has emerge/s:\${br_prefix}:${EPREFIX}:" -i neofetch \
			|| die "Failed to adjust for Prefix"
	fi

	default
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install-neofetch
}

pkg_postinst() {
	optfeature "displaying images" "media-libs/imlib2 www-client/w3m[imlib]"
	optfeature "gpu detection" sys-apps/pciutils
	optfeature "thumbnail creation" media-gfx/imagemagick
	optfeature "wallpaper" media-gfx/feh x11-misc/nitrogen
	optfeature "window size" x11-misc/xdotool "x11-apps/xwininfo x11-apps/xprop" "x11-apps/xwininfo x11-apps/xdpyinfo"
}
