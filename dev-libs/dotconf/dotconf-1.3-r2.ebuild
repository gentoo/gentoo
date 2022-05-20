# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="dot.conf configuration file parser"
HOMEPAGE="https://github.com/williamh/dotconf"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=">=sys-devel/autoconf-2.58"
RDEPEND=""

src_configure() {
	econf --disable-static
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
