# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A very basic terminfo library"
HOMEPAGE="https://github.com/neovim/unibilium/"
SRC_URI="https://github.com/neovim/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+ MIT"
SLOT="0/4"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~x64-macos"

BDEPEND="dev-lang/perl"

PATCHES=(
	"${FILESDIR}/${PN}-2.1.2-no-compress-man.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}
