# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Ataxx/Hexxagon clone"
HOMEPAGE="https://github.com/mangobrain/Infector/"
SRC_URI="http://infector.mangobrain.co.uk/downloads/${P}.tar.xz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
BDEPEND="virtual/pkgconfig
    >=sys-devel/gettext-0.19.8"

RDEPEND=">=dev-cpp/gtkmm-3.22:3.0
    >=dev-libs/libsigc++-2.10:2
    gnome-base/librsvg"

DEPEND="${RDEPEND}"
