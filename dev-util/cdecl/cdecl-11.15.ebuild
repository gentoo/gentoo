# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION='Composing and deciphering C (or C++) declarations or casts, aka "gibberish."'
HOMEPAGE="https://github.com/paul-j-lucas/cdecl"
SRC_URI="https://github.com/paul-j-lucas/${PN}/archive/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="+readline"

DEPEND="
	sys-libs/ncurses:0=
	readline? ( sys-libs/readline:0= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
"

S="${WORKDIR}/${PN}-${P}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_with readline)
}
