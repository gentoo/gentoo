# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnustep-2

DESCRIPTION="Simple image viewer"
HOMEPAGE="https://salsa.debian.org/gnustep-team/preview.app"
SRC_URI="mirror://gentoo//${P/p/P}.tar.gz"
S="${WORKDIR}/${PN/p/P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

PATCHES=(
	# Fix compilation, patch from debian
	"${FILESDIR}"/${PN}-0.8.5-compilation-errors.patch
)

src_prepare() {
	default
	sed -e 's/sel_eq(/sel_isEqual(/' -i Document.m || die
}
