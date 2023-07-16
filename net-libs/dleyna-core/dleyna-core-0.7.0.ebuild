# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="utility library for higher level dLeyna libraries"
HOMEPAGE="https://gitlab.gnome.org/World/dLeyna https://github.com/phako/dleyna-core"
SRC_URI="https://github.com/phako/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="1.0/5" # soname of libdleyna-core-1.0.so
KEYWORDS="amd64 ~arm64 ~riscv x86"

RDEPEND="
	>=dev-libs/glib-2.28:2
	>=net-libs/gupnp-1.2.0:0=
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"
