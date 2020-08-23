# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="utility to set the name of your window manager"
HOMEPAGE="https://tools.suckless.org/x/wmname"
SRC_URI="https://dl.suckless.org/tools/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-buildsystem.patch )

src_compile() {
	emake CC="$(tc-getCC)" LD="$(tc-getCC)"
}

src_install() {
	emake CC="$(tc-getCC)" LD="$(tc-getCC)" \
		PREFIX="${EPREFIX}"/usr DESTDIR="${D}" install
	einstalldocs
}
