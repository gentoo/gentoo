# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils autotools

DESCRIPTION="Identify/delete duplicate files residing within specified directories"
HOMEPAGE="https://github.com/adrianlopezroche/fdupes"
SRC_URI="https://github.com/adrianlopezroche/${PN}/releases/download/${PV}/${P}.tar.gz"
IUSE="ncurses"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"

DEPEND="ncurses? ( sys-libs/ncurses:0[tinfo] )"

src_prepare() {
	use ncurses && export LIBS=-ltinfow
	eautoreconf
	eapply_user
}

src_configure() {
	econf $(use_with ncurses ncurses)
}

src_install() {
	dobin "${PN}"
	doman "${PN}.1"
	einstalldocs
}
