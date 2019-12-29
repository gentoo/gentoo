# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
MY_PN=${PN}2
MY_P=${MY_PN}-${PV}
inherit cmake-multilib

DESCRIPTION="Official GTK+:2 port of KDE's Oxygen widget style"
HOMEPAGE="https://store.kde.org/p/1005553/"
SRC_URI="mirror://kde/stable/${MY_PN}/${PV}/src/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
KEYWORDS="amd64 ~ppc x86"
SLOT="2"
IUSE="debug"

BDEPEND="virtual/pkgconfig"
DEPEND="
	dev-libs/dbus-glib[${MULTILIB_USEDEP}]
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	x11-libs/cairo[${MULTILIB_USEDEP}]
	x11-libs/gdk-pixbuf[${MULTILIB_USEDEP}]
	x11-libs/gtk+:2[${MULTILIB_USEDEP}]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/pango[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}
	!x11-themes/oxygen-gtk:0
"

PATCHES=(
	"${FILESDIR}/${P}-xul.patch"
	"${FILESDIR}/${P}-eclipse.patch"
	"${FILESDIR}/${P}-qtpaths.patch"
	"${FILESDIR}/${P}-warning.patch"
	"${FILESDIR}/${P}-demo-optional.patch"
	"${FILESDIR}/${P}-tabstyle.patch"
)

S=${WORKDIR}/${MY_P}

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

	cat <<-EOF > 99oxygen-gtk2
CONFIG_PROTECT="${EPREFIX}/usr/share/themes/oxygen-gtk/gtk-2.0"
EOF
	doenvd 99oxygen-gtk2
}
