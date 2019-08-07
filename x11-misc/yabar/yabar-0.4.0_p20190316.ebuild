# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT="a0d3fdfed992149b741eb8fcf53f02b5d1a6142e"
DESCRIPTION="A modern and lightweight status bar for X window managers"
HOMEPAGE="https://github.com/geommer/yabar"
SRC_URI="https://github.com/geommer/yabar/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="playerctl"

DEPEND="
	app-text/asciidoc
	dev-libs/libconfig:=
	media-libs/alsa-lib
	net-wireless/wireless-tools
	x11-libs/cairo[xcb]
	x11-libs/gdk-pixbuf:2
	x11-libs/libxkbcommon[X]
	x11-libs/pango
	x11-libs/xcb-util-wm
	playerctl? ( media-sound/playerctl )
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	default
	# Respect CFLAGS and LDFLAGS
	# Declare VERSION without relying on git
	# Replace playerctl dependency option with basename
	sed -i -e "s:-flto -O2::g" -e "s:-Wall::" \
	-e "s:\$(shell git describe):0.4.0-179-ga0d3fdf:" \
	-e "s:^DEPS += playerctl-1.0:DEPS += playerctl:" \
	Makefile || die "Failed to update Makefile"
}

src_compile() {
	if use playerctl; then
		emake PLAYERCTL=1
	else
		emake
	fi
}

src_install() {
	default
	docinto examples
	dodoc examples/example.config
	docompress -x "/usr/share/doc/${PF}/examples"
}

pkg_postinst() {
	elog "An example yabar configuration file can be found in"
	elog "the following path: /usr/share/doc/${PF}/examples"
}
