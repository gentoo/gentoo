# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Implementation of POSIX bc with GNU extensions"
HOMEPAGE="https://git.yzena.com/gavin/bc"
SRC_URI="https://github.com/gavinhoward/bc/releases/download/${PV}/bc-${PV}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

S="${WORKDIR}/bc-${PV}"

src_configure() {
	EXECSUFFIX="-gh" PREFIX="${EPREFIX}/usr" ./configure.sh -GTl -sbc.banner -sdc.tty_mode || die
}
