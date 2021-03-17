# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson xdg

DESCRIPTION="A One Time Password and S/Key calculator for GTK+"
HOMEPAGE="http://www.killa.net/infosec/otpCalc/
	https://gitlab.com/ulm/otpcalc"
SRC_URI="https://gitlab.com/ulm/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~sparc x86"

RDEPEND="dev-libs/openssl:0=
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"
