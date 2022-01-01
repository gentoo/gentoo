# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="utility library for higher level dLeyna libraries"
HOMEPAGE="https://github.com/phako/dleyna-connector-dbus"
SRC_URI="https://github.com/phako/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="1.0"
KEYWORDS="amd64 ~arm64 x86"

DEPEND="
	>=dev-libs/glib-2.28:2
	>=net-libs/dleyna-core-0.7.0:1.0=
"
RDEPEND="${DEPEND}
	>=sys-apps/dbus-1
"
BDEPEND="virtual/pkgconfig"
