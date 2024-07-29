# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Microwave and RF transmission line calculator"
HOMEPAGE="http://transcalc.sourceforge.net"
SRC_URI="http://transcalc.sourceforge.net/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}"

# patch from debian
PATCHES=(
	"${FILESDIR}"/${P}-fd-perm.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	default

	# respect flags
	sed -i -e 's|^CFLAGS=|#CFLAGS=|g' configure || die
	# syntax errors
	sed -i \
		-e 's/ythesize/ynthesize/g' \
		src/{setup_menu.c,help.h} docs/transcalc.sgml README || die
}
