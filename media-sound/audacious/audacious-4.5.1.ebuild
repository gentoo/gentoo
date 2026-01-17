# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="Lightweight and versatile audio player"
HOMEPAGE="https://audacious-media-player.org/"
SRC_URI="https://distfiles.audacious-media-player.org/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~riscv ~x86"
IUSE="gtk qt6 test"
REQUIRED_USE="test? ( qt6 )"
RESTRICT="!test? ( test )"

BDEPEND="
	>=dev-util/gdbus-codegen-2.80.5-r1
	sys-devel/gettext
	virtual/pkgconfig
"
DEPEND="
	dev-libs/glib:2
	virtual/freedesktop-icon-theme
	gtk? (
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		>=x11-libs/gtk+-3.18:3
		x11-libs/pango
	)
	qt6? (
		dev-qt/qtbase:6[gui,widgets]
		dev-qt/qtsvg:6
	)
"
RDEPEND="${DEPEND}"
PDEPEND="~media-plugins/audacious-plugins-${PV}[gtk=,qt6=]"

PATCHES=(
	# Avoid superfluous handling for X11/Wayland with gtk+, warn in pkg_postinst instead.
	"${FILESDIR}"/${PN}-4.5.1-rm_gdk_symbols.patch
)

src_configure() {
	# D-Bus is a mandatory dependency. Remote control,
	# session management and some plugins depend on this.
	# Building without D-Bus is *unsupported* and a USE-flag
	# will not be added due to the bug reports that will result.
	# Bugs #197894, #199069, #207330, #208606
	local emesonargs=(
		-Ddbus=true
		$(meson_use qt6 qt)
		-Dqt5=false
		$(meson_use gtk)
		-Dgtk2=false
		-Dlibarchive=false
		-Dbuildstamp="Gentoo ${P}"
		-Dvalgrind=false
	)
	meson_src_configure

	if use test; then
		emesonargs=()
		EMESON_SOURCE="${S}"/src/libaudcore/tests \
		BUILD_DIR="${WORKDIR}"/${P}-libaudcore_tests-build \
		meson_src_configure
	fi
}

src_compile() {
	meson_src_compile

	if use test; then
		EMESON_SOURCE="${S}"/src/libaudcore/tests \
		BUILD_DIR="${WORKDIR}"/${P}-libaudcore_tests-build \
		meson_src_compile
	fi
}

src_test() {
	BUILD_DIR="${WORKDIR}"/${P}-libaudcore_tests-build meson_src_test
}

pkg_postinst() {
	if use gtk || use qt6; then
		ewarn "Audacious without X11/XWayland is unsupported."
		ewarn "Especially the Winamp interface is not usable yet on Wayland."
	fi
	xdg_pkg_postinst
}
