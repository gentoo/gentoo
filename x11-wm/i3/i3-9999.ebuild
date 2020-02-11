# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3

DESCRIPTION="An improved dynamic tiling window manager"
HOMEPAGE="https://i3wm.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/i3/i3"
EGIT_BRANCH="next"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="doc"

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
	>=x11-libs/cairo-1.14.4[X,xcb(+)]
	>=x11-libs/pango-1.30.0[X]"
DEPEND="${CDEPEND}
	doc? ( app-text/asciidoc app-text/xmlto dev-lang/perl )
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	dev-lang/perl
	dev-perl/AnyEvent-I3
	dev-perl/JSON-XS"

PATCHES=(
	"${FILESDIR}/${PN}-4.16-musl-GLOB_TILDE.patch"
)

src_prepare() {
	default

	if ! use doc ; then
		sed -e '/AC_PATH_PROG(\[PATH_ASCIIDOC/d' -i configure.ac || die
	fi
	eautoreconf

	cat <<- EOF > "${T}"/i3wm
		#!/bin/sh
		exec /usr/bin/i3
	EOF
}

src_configure() {
	local myeconfargs=( --enable-debug=no )  # otherwise injects -O0 -g
	econf "${myeconfargs[@]}"
}

src_compile() {
	emake -C "${CBUILD}"
}

src_install() {
	emake -C "${CBUILD}" DESTDIR="${D}" install
	einstalldocs

	exeinto /etc/X11/Sessions
	doexe "${T}"/i3wm
}

pkg_postinst() {

	# Only show the elog information on a new install
	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "There are several packages that you may find useful with ${PN} and"
		elog "their usage is suggested by the upstream maintainers, namely:"
		elog "  x11-misc/dmenu"
		elog "  x11-misc/i3status"
		elog "  x11-misc/i3lock"
		elog "Please refer to their description for additional info."
	fi
}
