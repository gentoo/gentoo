# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Pidgin plugin to define global hotkeys for various actions"
HOMEPAGE="https://sourceforge.net/projects/pidgin-hotkeys/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~riscv ~x86"

RDEPEND="net-im/pidgin[gtk]
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_install() {
	default

	find "${D}" -type f -name '*.la' -delete || die
}
