# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Service that allows to discover and manipulate DLNA Digital Media servers (DMS)"
HOMEPAGE="https://gitlab.gnome.org/World/dLeyna/ https://github.com/phako/dleyna-server"
SRC_URI="https://github.com/phako/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

RDEPEND="
	>=dev-libs/glib-2.36:2
	>=net-libs/gssdp-1.2:0=
	>=net-libs/gupnp-1.2:0=
	>=net-libs/gupnp-av-0.12.9:=
	>=media-libs/gupnp-dlna-0.9.4:2.0=
	>=net-libs/libsoup-2.42.0:2.4
	>=net-libs/dleyna-core-0.6.0:1.0=
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"
