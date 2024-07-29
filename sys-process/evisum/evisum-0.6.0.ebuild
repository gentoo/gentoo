# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="System and process monitor written with EFL"
HOMEPAGE="https://www.enlightenment.org/"
SRC_URI="https://download.enlightenment.org/rel/apps/${PN}/${P}.tar.xz"

LICENSE="GPL-2 ISC"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

DEPEND=">=dev-libs/efl-1.26.1"
RDEPEND="|| ( dev-libs/efl[X] dev-libs/efl[wayland] )"

DOCS=( BUGS NEWS README TODO )
