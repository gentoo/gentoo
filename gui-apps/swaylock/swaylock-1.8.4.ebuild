# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fcaps meson

DESCRIPTION="Screen locker for Wayland"
HOMEPAGE="https://github.com/swaywm/swaylock"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/swaywm/${PN}.git"
else
	SRC_URI="https://github.com/swaywm/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+gdk-pixbuf +pam"

DEPEND="
	dev-libs/wayland
	x11-libs/cairo
	x11-libs/libxkbcommon
	gdk-pixbuf? (
		dev-libs/glib:2
		x11-libs/gdk-pixbuf:2
	)
	pam? ( sys-libs/pam )
	!pam? ( virtual/libcrypt:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	app-text/scdoc
	>=dev-libs/wayland-protocols-1.25
	>=dev-util/wayland-scanner-1.15
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_feature pam)
		$(meson_feature gdk-pixbuf)
		-Dman-pages=enabled
		-Dfish-completions=true
		-Dzsh-completions=true
		-Dbash-completions=true
	)

	meson_src_configure
}

src_install() {
	meson_src_install
	use pam || fperms u+s /usr/bin/swaylock
}

pkg_postinst() {
	use pam || fcaps -M u-s cap_dac_read_search usr/bin/swaylock
}
