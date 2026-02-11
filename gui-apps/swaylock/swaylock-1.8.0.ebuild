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
	inherit verify-sig
	SRC_URI="https://github.com/swaywm/${PN}/releases/download/v${PV}/${P}.tar.gz -> ${P}.gh.tar.gz
		https://github.com/swaywm/${PN}/releases/download/v${PV}/${P}.tar.gz.sig -> ${P}.gh.tar.gz.sig"
	KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+gdk-pixbuf +man +pam"

DEPEND="
	dev-libs/wayland
	x11-libs/cairo
	x11-libs/libxkbcommon
	virtual/libcrypt:=
	gdk-pixbuf? ( x11-libs/gdk-pixbuf:2 )
	pam? ( sys-libs/pam )
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-libs/wayland-protocols-1.25
	>=dev-util/wayland-scanner-1.15
	virtual/pkgconfig
	man? ( app-text/scdoc )
"

if [[ ${PV} != 9999 ]]; then
	BDEPEND+=" verify-sig? ( sec-keys/openpgp-keys-emersion )"
	VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/emersion.asc"
fi

src_configure() {
	local emesonargs=(
		$(meson_feature man man-pages)
		$(meson_feature pam)
		$(meson_feature gdk-pixbuf)
		-Dfish-completions=true
		-Dzsh-completions=true
		-Dbash-completions=true
	)

	meson_src_configure
}

pkg_postinst() {
	use !pam && fcaps -m u+s cap_sys_admin usr/bin/swaylock
}
