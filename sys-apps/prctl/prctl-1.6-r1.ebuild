# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Tool to query and modify process behavior"
HOMEPAGE="https://sourceforge.net/projects/prctl/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-no-implicits.patch
)

src_prepare() {
	default

	cp "${FILESDIR}"/{Makefile.am,configure.ac} ./ || die
	eautoreconf
}
