# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="ncurses-based Nibbles clone"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${PN^}.${PV}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-libs/ncurses:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_compile() {
	tc-export CC

	append-cppflags $($(tc-getPKG_CONFIG) --cflags ncurses || die)
	append-libs $($(tc-getPKG_CONFIG) --libs ncurses || die)

	emake LDLIBS="${LIBS}" gnake
}

src_install() {
	dobin gnake
	einstalldocs
}
