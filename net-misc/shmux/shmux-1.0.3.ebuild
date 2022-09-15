# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="run the same command across many hosts in parallel"
HOMEPAGE="http://web.taranis.org/shmux/"
SRC_URI="http://web.taranis.org/${PN}/dist/${P}.tgz"

LICENSE="shmux"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="pcre"
RESTRICT="test"

RDEPEND="
	pcre? ( dev-libs/libpcre )
	sys-libs/ncurses:0=
"

DEPEND="
	${RDEPEND}
	virtual/awk"

PATCHES=( "${FILESDIR}"/${P}-tinfo.patch )

DOCS=( CHANGES )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_with pcre)
}

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs
}
