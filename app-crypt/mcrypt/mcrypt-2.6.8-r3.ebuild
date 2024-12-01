# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="Replacement of the old unix crypt(1)"
HOMEPAGE="https://mcrypt.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/mcrypt/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="nls"

RDEPEND=">=dev-libs/libmcrypt-2.5.8
	>=app-crypt/mhash-0.9.9
	sys-libs/zlib"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2.6.7-qa.patch"
	"${FILESDIR}/${P}-stdlib.h.patch"
	"${FILESDIR}/${P}-segv.patch"
	"${FILESDIR}/${P}-sprintf.patch"
	"${FILESDIR}/${P}-format-string.patch"
	"${FILESDIR}/${P}-overflow.patch"
)

src_configure() {
	# bug #943960
	append-cflags -std=gnu17

	econf $(use_enable nls)
}
