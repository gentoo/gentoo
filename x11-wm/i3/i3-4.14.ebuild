# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="An improved dynamic tiling window manager"
HOMEPAGE="https://i3wm.org/"
# iw3m.org tarball for 4.14 is broken, see https://github.com/i3/i3/issues/2905
SRC_URI="https://github.com/i3/i3/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc debug test"
RESTRICT="!test? ( test )"

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
	>=x11-libs/cairo-1.14.4[X,xcb]
	>=x11-libs/pango-1.30.0[X]"
DEPEND="${CDEPEND}
	app-text/asciidoc
	doc? ( app-text/xmlto dev-lang/perl )
	test? (
		dev-perl/Module-Install
	)
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	dev-lang/perl
	dev-perl/AnyEvent-I3
	dev-perl/JSON-XS"

# Test without debug will apply optimization levels, which results
# in type-punned pointers - which in turn causes test failures.
REQUIRED_USE="test? ( debug )"

DOCS=(
	"RELEASE-NOTES-${PV}"
	docs
)
PATCHES=(
	"${FILESDIR}/${PN}-musl-GLOB_TILDE.patch"
)

src_test() {
	emake -C "${CBUILD}" check
}

src_prepare() {
	default

	cat <<- EOF > "${T}"/i3wm
		#!/bin/sh
		exec /usr/bin/i3
	EOF

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	emake -C "${CBUILD}"
}

src_install() {
	emake -C "${CBUILD}" DESTDIR="${D}" install
	doman "${CBUILD}"/man/*.1

	use doc && einstalldocs

	exeinto /etc/X11/Sessions
	doexe "${T}/i3wm"
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
