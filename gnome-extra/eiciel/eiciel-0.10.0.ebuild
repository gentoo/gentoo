# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit meson xdg

DESCRIPTION="ACL editor for GNOME, with Nautilus extension"
HOMEPAGE="https://rofi.roger-ferrer.org/eiciel/ https://github.com/rofirrim/eiciel"
SRC_URI="https://github.com/rofirrim/eiciel/archive/refs/tags/${PV/_/-}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nautilus xattr"

DEPEND="
	>=sys-apps/acl-2.2.32
	>=dev-cpp/gtkmm-4.6:4.0
	dev-cpp/glibmm:2.68
	>=gnome-base/nautilus-43
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	>=sys-devel/gettext-0.18.1
"
