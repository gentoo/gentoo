# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Dos2Unix like text file converter"
HOMEPAGE="https://www.hany.sk/~hany/software/hd2u/"
SRC_URI="https://www.hany.sk/~hany/_data/hd2u/${P}.tgz"

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND="
	dev-libs/popt"
RDEPEND="${DEPEND}
	!app-text/dos2unix"

PATCHES=( "${FILESDIR}"/${P}-build-honor-LDFLAGS.patch )
