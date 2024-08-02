# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="alterMIME is a small program which is used to alter your mime-encoded mailpacks"
HOMEPAGE="https://pldaniels.com/altermime/"
SRC_URI="https://www.pldaniels.com/altermime/${P}.tar.gz"

LICENSE="Sendmail"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-0.3.10-MIME_headers-overflow.patch
	"${FILESDIR}"/${P}-respect-flags.patch
)

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin altermime
	dodoc CHANGELOG README
}
