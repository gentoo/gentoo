# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Program to link two /dev/net/tun to form virtual ethernet"
HOMEPAGE="https://grumpf.hope-2000.org/"
SRC_URI="https://grumpf.hope-2000.org/${PN}.c -> ${P}.c"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
PATCHES=( "${FILESDIR}/${P}-missing-include.patch" )

src_unpack() {
	cp "${DISTDIR}/${P}.c" "${PN}.c" || die
}

src_compile() {
	emake CC="$(tc-getCC)" "${PN}"
}

src_install() {
	dobin "${PN}"
}
