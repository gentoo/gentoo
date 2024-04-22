# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
fi
inherit autotools toolchain-funcs

DESCRIPTION="dot.conf configuration file parser"
HOMEPAGE="https://github.com/williamh/dotconf"
if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://github.com/williamh/dotconf.git"
else
	SRC_URI="https://github.com/williamh/dotconf/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="LGPL-2.1"
SLOT="0"

DEPEND=">=dev-build/autoconf-2.58"

src_configure() {
	eautoreconf
	econf --disable-static
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
