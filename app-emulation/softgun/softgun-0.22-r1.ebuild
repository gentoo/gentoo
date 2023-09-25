# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="ARM software emulator"
HOMEPAGE="https://softgun.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="media-libs/alsa-lib"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.22-make.patch
	"${FILESDIR}"/${PN}-0.22-fix-implicit-int.patch
	"${FILESDIR}"/${PN}-0.22-fix-declarations-with-type-mismatches.patch
)

src_configure() {
	append-cflags -fcommon
	default
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dodir /usr/bin
	emake install prefix="${D}/usr"
	dodoc README configs/*.sg
}
