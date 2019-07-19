# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="A lightweight notification daemon for Wayland. Works on Sway."
HOMEPAGE="https://github.com/emersion/mako"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/emersion/${PN}.git"
else
	SRC_URI="https://github.com/emersion/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+icons"

DEPEND="
	dev-libs/wayland
	x11-libs/pango
	x11-libs/cairo
	|| (
		sys-apps/systemd
		sys-auth/elogind
	)
	sys-apps/dbus[user-session]
	icons? (
		x11-libs/gtk+:3
		x11-libs/gdk-pixbuf
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
	app-text/scdoc
"

src_configure() {
	local emesonargs=(
		-Dicons=$(usex icons enabled disabled)
		"-Dwerror=false"
	)
	meson_src_configure
}
