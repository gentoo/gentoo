# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Implementation of POSIX bc with GNU extensions"
HOMEPAGE="https://github.com/gavinhoward/bc"
SRC_URI="https://github.com/gavinhoward/bc/releases/download/${PV}/bc-${PV}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/bc-${PV}"

src_configure() {
	EXECSUFFIX="-gh" PREFIX="${EPREFIX}/usr" ./configure.sh -GT || die
}
