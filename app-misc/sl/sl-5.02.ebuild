# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="sophisticated graphical program which corrects your miss typing"
HOMEPAGE="http://www.tkl.iis.u-tokyo.ac.jp/~toyoda/index_e.html https://github.com/mtoyoda/sl/"
SRC_URI="https://github.com/mtoyoda/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Toyoda"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="l10n_ja"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -e "s/-lncurses/$($(tc-getPKG_CONFIG) --libs ncurses)/" -i Makefile || die
}

src_install() {
	dobin "${PN}"
	doman "${PN}.1"
	local DOCS=( README.md )
	if use l10n_ja; then
		newman ${PN}.1.ja ${PN}.ja.1
		DOCS+=( README.ja.md )
	fi
	einstalldocs
}
