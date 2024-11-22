# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="A One Time Password and S/Key calculator for GTK+"
HOMEPAGE="https://gitlab.com/otpcalc/otpcalc
	http://www.killa.net/infosec/otpCalc/"
SRC_URI="https://gitlab.com/otpcalc/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"

RDEPEND="dev-libs/openssl:0=
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"
