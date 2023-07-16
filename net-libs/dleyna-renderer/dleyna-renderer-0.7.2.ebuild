# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="A library to discover and manipulate DLNA renderers"
HOMEPAGE="https://github.com/phako/dleyna-renderer https://github.com/phako/dleyna-renderer"
SRC_URI="https://github.com/phako/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~riscv"

DEPEND="
	>=dev-libs/glib-2.28:2
	>=net-libs/gssdp-1.2.0:0=
	>=net-libs/gupnp-1.2.0:0=
	>=net-libs/gupnp-av-0.12.9
	>=media-libs/gupnp-dlna-0.9.4:2.0
	>=net-libs/libsoup-2.42.0:2.4
	>=net-libs/dleyna-core-0.7.0:1.0=
"
RDEPEND="${DEPEND}
	net-libs/dleyna-connector-dbus
"
BDEPEND="
	dev-libs/libxslt
	virtual/pkgconfig
"
