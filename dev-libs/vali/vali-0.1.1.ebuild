# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="C library and code generator for Varlink"
HOMEPAGE="https://gitlab.freedesktop.org/emersion/vali"
SRC_URI="https://gitlab.freedesktop.org/emersion/vali/-/archive/v${PV}/vali-v${PV}.tar.bz2"
S=${WORKDIR}/${PN}-v${PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

DEPEND="
	dev-libs/aml
	dev-libs/json-c:=
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"
