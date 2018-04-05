# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 gnome2-utils xdg

MY_PN="DisplayCAL"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Display calibration and characterization powered by Argyll CMS"
HOMEPAGE="https://displaycal.net/"
SRC_URI="mirror://sourceforge/dispcalgui/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=media-gfx/argyllcms-1.1.0
	dev-python/wxpython:3.0
	>=x11-libs/libX11-1.3.3
	>=x11-apps/xrandr-1.3.2
	>=x11-libs/libXxf86vm-1.1.0
	>=x11-proto/xineramaproto-1.2
	>=x11-libs/libXinerama-1.1
"
RDEPEND="${DEPEND}
	>=dev-python/numpy-1.2.1
"

# Just in case someone renames the ebuild
S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Do not generate udev/hotplug files
	sed -e '/if os.path.isdir/s#/etc/udev/rules.d\|/etc/hotplug#\0-non-existant#' \
		-i DisplayCAL/setup.py || die
	# Prohibit setup from running xdg-* programs, resulting to sandbox violation
	sed -e '/if which/s#xdg-icon-resource#\0-non-existant#' \
		-e '/if which/s#xdg-desktop-menu#\0-non-existant#' \
		-i DisplayCAL/postinstall.py || die

	# Remove deprecated Encoding key from .desktop file
	sed -e '/Encoding=UTF-8/d' -i misc/*.desktop  || die

	# Remove x-world Media Type
	sed -e 's/x\-world\/x\-vrml\;//g' \
		-i misc/displaycal-vrml-to-x3d-converter.desktop || die

	distutils-r1_src_prepare
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
}
