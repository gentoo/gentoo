# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_PN="${PN/asfr/ASFR}"

DESCRIPTION="Linux WindowsMedia streaming client"
HOMEPAGE="https://sourceforge.net/projects/asfrecorder/"
SRC_URI="mirror://gentoo/${MY_PN}.zip"
S="${WORKDIR}/${MY_PN}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ppc x86 ~x86-linux ~ppc-macos"

BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${P}-headers.patch
)

src_compile() {
	tc-export CC
	emake -C source ${PN}
}

src_install() {
	dobin source/${PN}
	einstalldocs
}
