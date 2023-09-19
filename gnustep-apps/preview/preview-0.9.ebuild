# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnustep-2

DESCRIPTION="Simple image viewer"
HOMEPAGE="http://www.sonappart.net/softwares/preview/"
SRC_URI="http://www.sonappart.net/softwares/preview/download/${P/p/P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

S=${WORKDIR}/${PN/p/P}

PATCHES=(
	# Fix compilation, patch from debian
	"${FILESDIR}"/${PN}-0.8.5-compilation-errors.patch
)

src_prepare() {
	default
	sed -e 's/sel_eq(/sel_isEqual(/' -i Document.m || die
}
