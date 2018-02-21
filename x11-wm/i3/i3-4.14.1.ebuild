# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

AEVER=0.17

inherit autotools out-of-source virtualx

DESCRIPTION="An improved dynamic tiling window manager"
HOMEPAGE="https://i3wm.org/"
SRC_URI="https://i3wm.org/downloads/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc debug test"

CDEPEND="dev-libs/libev
	dev-libs/libpcre
	>=dev-libs/yajl-2.0.3
	x11-libs/libxcb[xkb]
	x11-libs/libxkbcommon[X]
	x11-libs/startup-notification
	x11-libs/xcb-util
	x11-libs/xcb-util-cursor
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-wm
	x11-libs/xcb-util-xrm
	x11-misc/xkeyboard-config
	>=x11-libs/cairo-1.14.4[X,xcb]
	>=x11-libs/pango-1.30.0[X]"
DEPEND="${CDEPEND}
	app-text/asciidoc
	doc? ( app-text/xmlto dev-lang/perl )
	test? (
		dev-perl/AnyEvent
		>=dev-perl/X11-XCB-0.120.0
		dev-perl/Inline
		dev-perl/Inline-C
		dev-perl/IPC-Run
		dev-perl/ExtUtils-PkgConfig
		dev-perl/local-lib
		>=virtual/perl-Test-Simple-0.940.0
		x11-base/xorg-server[xephyr]
	)
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	dev-lang/perl
	dev-perl/AnyEvent-I3
	dev-perl/JSON-XS"

# Test without debug will apply optimization levels, which results
# in type-punned pointers - which in turn causes test failures.
REQUIRED_USE="test? ( debug )"

PATCHES=(
	"${FILESDIR}/${PN}-musl-GLOB_TILDE.patch"
)

# https://github.com/i3/i3/issues/3013
RESTRICT="test"

src_prepare() {
	default

	cat <<- EOF > "${T}"/i3wm
		#!/bin/sh
		exec /usr/bin/i3
	EOF

	eautoreconf
}

my_src_configure() {
	local myeconfargs=(
		$(use_enable debug)
	)
	econf "${myeconfargs[@]}"
}

my_src_test() {
	emake \
		test.commands_parser \
		test.config_parser \
		test.inject_randr15

	virtx perl \
		-I "${S}/testcases/lib" \
		-I "${BUILD_DIR}/testcases/lib" \
		testcases/complete-run.pl
}

my_src_install_all() {
	doman man/*.1

	einstalldocs
	use doc && dodoc -r docs "RELEASE-NOTES-${PV}"

	exeinto /etc/X11/Sessions
	doexe "${T}/i3wm"
}

pkg_postinst() {
	einfo "There are several packages that you may find useful with ${PN} and"
	einfo "their usage is suggested by the upstream maintainers, namely:"
	einfo "  x11-misc/dmenu"
	einfo "  x11-misc/i3status"
	einfo "  x11-misc/i3lock"
	einfo "Please refer to their description for additional info."
}
