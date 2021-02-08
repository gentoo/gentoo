# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson xdg

DESCRIPTION="System and process monitor written with EFL"
HOMEPAGE="https://www.enlightenment.org/"
SRC_URI="https://download.enlightenment.org/rel/apps/${PN}/${P}.tar.xz"

LICENSE="GPL-2 ISC"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="dev-libs/efl"
RDEPEND="|| ( dev-libs/efl[X] dev-libs/efl[wayland] )"
