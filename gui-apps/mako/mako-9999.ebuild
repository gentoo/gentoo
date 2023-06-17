# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson systemd

DESCRIPTION="A lightweight notification daemon for Wayland. Works on Sway"
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
IUSE="elogind +icons systemd"

RDEPEND="
	dev-libs/wayland
	x11-libs/pango
	x11-libs/cairo
	|| (
		systemd? ( sys-apps/systemd )
		elogind? ( sys-auth/elogind )
		sys-libs/basu
	)
	sys-apps/dbus
	icons? (
		x11-libs/gtk+:3
		x11-libs/gdk-pixbuf
	)
"
DEPEND="
	${RDEPEND}
	>=dev-libs/wayland-protocols-1.21
"
BDEPEND="
	app-text/scdoc
	dev-util/wayland-scanner
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dicons=$(usex icons enabled disabled)
		-Dzsh-completions=true
		-Dfish-completions=true
		-Dbash-completions=true
	)

	if use systemd ; then
		emesonargs+=( -Dsd-bus-provider=libsystemd )
	elif use elogind ; then
		emesonargs+=( -Dsd-bus-provider=libelogind )
	else
		emesonargs+=( -Dsd-bus-provider=basu )
	fi

	meson_src_configure
}

src_install() {
	meson_src_install

	systemd_douserunit contrib/systemd/mako.service
}
