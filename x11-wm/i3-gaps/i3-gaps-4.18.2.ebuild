# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools out-of-source

DESCRIPTION="i3 fork with gaps and some more features"
HOMEPAGE="https://github.com/Airblader/i3"
SRC_URI="https://github.com/Airblader/i3/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

CDEPEND="dev-libs/glib:2
	dev-libs/libev
	dev-libs/libpcre
	dev-libs/yajl
	x11-libs/cairo[X,xcb(+)]
	x11-libs/libxcb[xkb]
	x11-libs/libxkbcommon[X]
	x11-libs/pango[X]
	x11-libs/startup-notification
	x11-libs/xcb-util
	x11-libs/xcb-util-cursor
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-wm
	x11-libs/xcb-util-xrm
"
DEPEND="${CDEPEND}
	test? (
		dev-perl/ExtUtils-PkgConfig
		dev-perl/IPC-Run
		dev-perl/Inline
		dev-perl/Inline-C
		dev-perl/X11-XCB
		dev-perl/XS-Object-Magic
		x11-base/xorg-server[xephyr,xvfb]
		x11-misc/xvfb-run
	)
"
BDEPEND="
	app-text/asciidoc
	app-text/xmlto
	dev-lang/perl
	virtual/pkgconfig
"
RDEPEND="${CDEPEND}
	dev-lang/perl
	dev-perl/AnyEvent-I3
	dev-perl/JSON-XS
	!x11-wm/i3
"

S="${WORKDIR}/i3-${PV}"

DOCS=( RELEASE-NOTES-$(ver_cut 1-3) )

PATCHES=(
	"${FILESDIR}/${PN}-$(ver_cut 1-2)-musl.patch"
	"${FILESDIR}/${PN}-4.18.2-drop-branch-test.patch"
)

src_prepare() {
	default
	eautoreconf
}

my_src_configure() {
	# disable sanitizer: otherwise injects -O0 -g
	local myeconfargs=(
		$(use_enable doc docs)
		--enable-debug=no
		--enable-mans
		--disable-sanitizers
	)
	econf "${myeconfargs[@]}"
}

my_src_install_all() {
	doman "${BUILD_DIR}"/man/*.1
	einstalldocs

	exeinto /etc/X11/Sessions
	newexe - i3wm <<- EOF
		#!/usr/bin/env sh
		exec /usr/bin/i3
	EOF
}

pkg_postinst() {
	einfo "There are several packages that you may find useful with ${PN} and"
	einfo "their usage is suggested by the upstream maintainers, namely:"
	einfo "  x11-misc/dmenu"
	einfo "  x11-misc/i3lock"
	einfo "  x11-misc/i3status"
	einfo "Please refer to their description for additional info."
}
