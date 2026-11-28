# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="library for Irman control of Unix software"
HOMEPAGE="https://www.lirc.org/software/snapshots/"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	tc-export CC LD AR RANLIB
	econf --disable-static
}

src_install() {
	export LIRC_DRIVER_DEVICE="${ED}/dev/lirc"
	default
	dodoc TECHNICAL

	dobin test_{func,io,name}

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
