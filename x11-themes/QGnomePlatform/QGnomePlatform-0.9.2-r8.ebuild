# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="Qt Platform Theme aimed to accommodate GNOME settings"
HOMEPAGE="https://github.com/FedoraQt/QGnomePlatform"
SRC_URI="https://github.com/FedoraQt/QGnomePlatform/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"
IUSE="wayland X"

DEPEND="
	>=dev-qt/qtbase-6.10:6=[dbus,gui,wayland?,widgets]
	>=dev-qt/qtdeclarative-6.10:6
	gnome-base/gsettings-desktop-schemas
	sys-apps/xdg-desktop-portal
	x11-libs/gtk+:3[wayland?,X?]
	>=x11-themes/adwaita-qt-1.4.2
"
RDEPEND="${DEPEND}"
BDEPEND="dev-qt/qtbase:6"

PATCHES=(
	"${FILESDIR}/${P}-cmake4.patch" # bugs #958301, #965856
	"${FILESDIR}/${P}-qt-6.10.patch" # bug #966354, #968100
)

src_configure() {
	# avoid automagic dep on src/theme/qgtk3dialoghelpers.cpp
	use X || append-cppflags -DGENTOO_GTK_HIDE_X11
	use wayland || append-cppflags -DGENTOO_GTK_HIDE_WAYLAND

	local mycmakeargs=(
		-DUSE_QT6=ON
		-DDISABLE_DECORATION_SUPPORT="$(usex wayland false true)"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# https://github.com/FedoraQt/QGnomePlatform/pull/150#issuecomment-1689693729
	insinto /etc/profile.d
	doins "${FILESDIR}/90-${PN}.sh"
}
