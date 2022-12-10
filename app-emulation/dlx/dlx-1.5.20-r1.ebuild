# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="DLX Simulator"
HOMEPAGE="https://www.davidviner.com/dlx"
SRC_URI="https://www.davidviner.com/zip/dlx/dlx.zip -> ${P}.zip"
S="${WORKDIR}"/dlx

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}/${P}-fix-implicit-function-declarations.patch"
	"${FILESDIR}/${P}-fix-lto-type-mismatch.patch"
)

src_compile() {
	# CXX not used
	emake CC="$(tc-getCC)" LINK="$(tc-getCC)" \
		CFLAGS="${CFLAGS} ${CPPFLAGS}" \
		LFLAGS="${CFLAGS} ${LDFLAGS}"
}

src_install() {
	dobin masm mon dasm
	dodoc README.txt MANUAL.TXT
}
