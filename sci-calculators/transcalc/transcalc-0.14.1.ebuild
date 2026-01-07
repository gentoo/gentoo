# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Microwave and RF transmission line calculator"
HOMEPAGE="https://transcalc.sourceforge.net"
SRC_URI="https://gitlab.com/oss-abandonware/sci-calculators/transcalc/-/archive/${PV}/transcalc-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
