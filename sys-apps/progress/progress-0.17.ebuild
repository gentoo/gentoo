# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Coreutils Viewer: show progress for cp, rm, dd, and so forth"
HOMEPAGE="https://github.com/Xfennec/progress"
SRC_URI="https://github.com/Xfennec/progress/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="sys-libs/ncurses:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# bug #945760
	tc-export CC PKG_CONFIG
}

src_install() {
	emake PREFIX="${ED}/usr" install
	dodoc README.md
}
