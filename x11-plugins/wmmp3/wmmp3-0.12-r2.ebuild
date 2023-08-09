# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Mp3 player dock app for WindowMaker; frontend to mpg123"
HOMEPAGE="https://www.dockapps.net/wmmp3"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	media-sound/mpg123
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}"/${P}-x_includes_n_libraries.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-fix-implicit-function-declaration-clang16.patch
	)

DOCS=( AUTHORS ChangeLog sample.wmmp3 README TODO )

src_compile() {
	emake prefix="/usr/"
}

pkg_postinst() {
	einfo "Please copy the sample.wmmp3 to your home directory and change it to fit your needs."
}
