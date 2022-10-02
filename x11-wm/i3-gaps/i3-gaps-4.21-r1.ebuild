# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson optfeature

DESCRIPTION="i3 fork with gaps and some more features"
HOMEPAGE="https://github.com/Airblader/i3"
SRC_URI="https://github.com/Airblader/i3/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/i3-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="dev-libs/glib:2
	dev-libs/libev
	dev-libs/libpcre2
	dev-libs/yajl:=
	x11-libs/cairo[X,xcb(+)]
	x11-libs/libxcb:=[xkb]
	x11-libs/libxkbcommon[X]
	x11-libs/pango[X]
	x11-libs/startup-notification
	x11-libs/xcb-util
	x11-libs/xcb-util-cursor
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-wm
	x11-libs/xcb-util-xrm"
DEPEND="${COMMON_DEPEND}
	test? (
		dev-perl/ExtUtils-PkgConfig
		dev-perl/IPC-Run
		dev-perl/Inline
		dev-perl/Inline-C
		dev-perl/X11-XCB
		dev-perl/XS-Object-Magic
		x11-apps/xhost
		x11-base/xorg-server[xephyr,xvfb]
		x11-misc/xvfb-run
	)"
BDEPEND="app-text/asciidoc
	app-text/xmlto
	dev-lang/perl
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	dev-lang/perl
	dev-perl/AnyEvent-I3
	dev-perl/JSON-XS
	!x11-wm/i3"

DOCS=( RELEASE-NOTES-$(ver_cut 1-3) )

PATCHES=(
	"${FILESDIR}/${PN}-4.18-musl.patch"
)

src_configure() {
	local emesonargs=(
		-Ddocdir="/usr/share/doc/${PF}"
		-Ddocs=$(usex doc true false)
		-Dmans=true
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	exeinto /etc/X11/Sessions
	newexe - i3wm <<- EOF
		#!/usr/bin/env sh
		exec /usr/bin/i3
	EOF
}

pkg_postinst() {
	optfeature "Application launcher" x11-misc/dmenu
	optfeature "Simple screen locker" x11-misc/i3lock
	optfeature "Status bar generator" x11-misc/i3status
}
