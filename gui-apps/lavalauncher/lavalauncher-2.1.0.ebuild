# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Simple launcher for wayland"
HOMEPAGE="https://git.sr.ht/~leon_plickat/lavalauncher"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.sr.ht/~leon_plickat/lavalauncher"
else
	SRC_URI="https://git.sr.ht/~leon_plickat/lavalauncher/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-v${PV}"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="+svg man"

RDEPEND="
	dev-libs/wayland
	x11-libs/cairo
	svg? ( gnome-base/librsvg )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/wayland-protocols
	virtual/pkgconfig
	man? ( >=app-text/scdoc-1.9.3 )
"

PATCHES=(
	"${FILESDIR}/lavalauncher-remove-werror.patch"
)

src_configure() {
	local emesonargs=(
		$(meson_feature man man-pages)
		$(meson_feature svg librsvg)
	)
	meson_src_configure
}
