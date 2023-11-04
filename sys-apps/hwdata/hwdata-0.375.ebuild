# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo

DESCRIPTION="Hardware identification and configuration data"
HOMEPAGE="https://github.com/vcrhonek/hwdata"
SRC_URI="https://github.com/vcrhonek/hwdata/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

RESTRICT="test"

src_configure() {
	# configure is not compatible with econf
	local conf=(
		./configure
		--prefix="${EPREFIX}/usr"
		--libdir="${EPREFIX}/lib"
		--datadir="${EPREFIX}/usr/share"
	)

	edo "${conf[@]}"
}
