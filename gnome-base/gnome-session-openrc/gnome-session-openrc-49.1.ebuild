# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit meson

DESCRIPTION="Gnome session leader for OpenRC"
HOMEPAGE="https://github.com/swagtoy/gnome-session-openrc"
SRC_URI="https://github.com/swagtoy/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="X"

COMMON_DEPEND="
	>=dev-libs/glib-2.82.0:2
	>=sys-auth/elogind-242
"
RDEPEND="${COMMON_DEPEND}
	sys-apps/dbus[X?]
	<gnome-base/gnome-session-49
"
DEPEND="${COMMON_DEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_use X x11)
	)
	meson_src_configure
}
