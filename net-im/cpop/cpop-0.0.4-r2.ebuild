# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="GTK+ network popup message client. Compatible with the jpop protocol"
HOMEPAGE="http://www.draxil.uklinux.net/hip/index.pl?page=cpop"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-implicit-exit_memset_strlen.patch
	"${FILESDIR}"/${P}-implicit-func-decls.patch
)

src_prepare() {
	default

	# Clang 16, bug #900072
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README
}
