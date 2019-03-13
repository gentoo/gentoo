# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Proof-of-concept GPG passphrase recovery tool"
HOMEPAGE="http://www.vanheusden.com/nasty/"
SRC_URI="http://www.vanheusden.com/nasty/${P}.tgz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RDEPEND="app-crypt/gpgme"
DEPEND="${RDEPEND}"

DOCS=(
	readme.txt
)

PATCHES=(
	"${FILESDIR}/${P}-flags.patch"
)

src_compile() {
	emake CC="$(tc-getCC)" DEBUG=
}

src_install() {
	einstalldocs
	dobin nasty
}
