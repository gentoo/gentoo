# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=${PN}3
MY_P=${MY_PN}-${PV}
PATCHSET=${PN}-patchset
inherit cmake-multilib

DESCRIPTION="Official GTK+:3 port of KDE's Oxygen widget style"
HOMEPAGE="https://store.kde.org/p/1005553/"
SRC_URI="mirror://kde/stable/${MY_PN}/${PV}/src/${MY_P}.tar.bz2
	https://dev.gentoo.org/~asturm/distfiles/${PATCHSET}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1"
SLOT="3"
KEYWORDS="amd64 ~ppc x86"

DEPEND="
	dev-libs/dbus-glib[${MULTILIB_USEDEP}]
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	x11-libs/cairo[${MULTILIB_USEDEP}]
	x11-libs/gdk-pixbuf[${MULTILIB_USEDEP}]
	x11-libs/gtk+:3[${MULTILIB_USEDEP},X]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/pango[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}
	!x11-themes/oxygen-gtk:0
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${WORKDIR}/${PATCHSET}/${PV}"
	"${WORKDIR}/${PATCHSET}/1.4.6/0005-demo-optional.patch"
	"${WORKDIR}/${PATCHSET}/1.4.6/0006-tabstyle.patch"
	"${WORKDIR}/${PATCHSET}/1.4.6/0007-cmake4.patch" # bug 955107
)

multilib_src_configure() {
	if ! multilib_is_native_abi; then
		local mycmakeargs=(
			-DENABLE_DEMO=OFF
		)
	fi
	cmake_src_configure
}

src_install() {
	cmake-multilib_src_install

	cat <<-EOF > 99oxygen-gtk3
CONFIG_PROTECT="${EPREFIX}/usr/share/themes/oxygen-gtk/gtk-3.0"
EOF
	doenvd 99oxygen-gtk3
}
