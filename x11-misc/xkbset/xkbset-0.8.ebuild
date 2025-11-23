# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="User preference utility for XKB extensions for X"
HOMEPAGE="https://github.com/stephenmontgomerysmith/xkbset"
SRC_URI="https://github.com/stephenmontgomerysmith/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${P/_p*/}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="tk"

DEPEND="x11-libs/libX11"
RDEPEND="
	${DEPEND}
	tk? ( dev-perl/Tk )
"
BDEPEND="dev-lang/perl"

PATCHES=(
	"${FILESDIR}"/${P}-clarify-errors.patch
)

src_compile() {
	emake CC="$(tc-getCC)" INC_PATH= LIB_PATH=
}

src_install() {
	dobin xkbset
	use tk && dobin xkbset-gui
	doman xkbset.1
	dodoc README TODO
}
