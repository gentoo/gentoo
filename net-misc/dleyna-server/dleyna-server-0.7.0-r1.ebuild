# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Service that allows to discover and manipulate DLNA Digital Media servers (DMS)"
HOMEPAGE="https://github.com/phako/dleyna-server"
SRC_URI="https://github.com/phako/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~mattst88/distfiles/${PF}-patchset.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-libs/glib-2.36:2
	>=net-libs/gssdp-1.2:0=
	>=net-libs/gupnp-1.2:0=
	>=net-libs/gupnp-av-0.11.5
	>=media-libs/gupnp-dlna-0.9.4:2.0
	>=net-libs/libsoup-2.28.2:2.4
	>=net-libs/dleyna-core-0.6.0:1.0=
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${WORKDIR}"/patches
)
