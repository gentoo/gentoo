# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="System tray utility including support for KDE system tray icons"
HOMEPAGE="https://d3adb5.github.io/stalonetray/index.html"
SRC_URI="https://github.com/d3adb5/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +graceful-exit kde xinerama +xpm"

RDEPEND="x11-libs/libX11
	xinerama? ( x11-libs/libXinerama )
	xpm? ( x11-libs/libXpm )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="app-text/docbook-xml-dtd
	dev-libs/libxslt"

DOCS=( AUTHORS README.md stalonetrayrc.sample )

src_configure() {
	meson_src_configure \
		$(meson_use debug dump_window_information) \
		$(meson_use debug trace_events) \
		$(meson_use graceful-exit exit_gracefully) \
		$(meson_feature kde native_kde) \
		$(meson_feature xinerama) \
		$(meson_feature xpm)
}
