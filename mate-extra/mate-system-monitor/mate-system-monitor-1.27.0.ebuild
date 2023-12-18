# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit mate toolchain-funcs

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
fi

DESCRIPTION="The MATE System Monitor"

LICENSE="FDL-1.1+ GPL-2+ LGPL-2+"
SLOT="0"
IUSE="elogind systemd wnck"

REQUIRED_USE="?? ( elogind systemd )"

COMMON_DEPEND="
	>=dev-cpp/glibmm-2.26:2
	>=dev-cpp/gtkmm-3.8:3.0
	>=dev-libs/glib-2.56:2
	dev-libs/libsigc++:2
	>=dev-libs/libxml2-2:2
	>=gnome-base/libgtop-2.37.2:2=
	>=gnome-base/librsvg-2.35:2
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3
	>=x11-libs/libwnck-3.0:3
	elogind? ( sys-auth/elogind )
	systemd? ( sys-apps/systemd )
"

RDEPEND="${COMMON_DEPEND}
	>=sys-auth/polkit-0.97:0
	virtual/libintl
"

DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	>=sys-devel/gettext-0.19.8
	>=sys-devel/autoconf-2.63:*
	virtual/pkgconfig
"

src_configure() {
	local myconf=()

	if use elogind || use systemd; then
		myconf+=( --enable-systemd )
		if use elogind; then
			local pkgconfig="$(tc-getPKG_CONFIG)"
			myconf+=(
				SYSTEMD_CFLAGS="$(${pkgconfig} --cflags 'libelogind')"
				SYSTEMD_LIBS="$(${pkgconfig} --libs 'libelogind')"
			)
		fi
	else
		myconf+=( --disable-systemd )
	fi

	mate_src_configure "${myconf[@]}" \
		$(use_enable wnck)
}
