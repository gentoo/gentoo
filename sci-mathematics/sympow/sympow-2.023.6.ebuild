# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Symmetric power elliptic curve L-functions"
HOMEPAGE="https://gitlab.com/rezozer/forks/sympow/"
SRC_URI="https://gitlab.com/rezozer/forks/sympow/-/archive/v${PV}/${PN}-v${PV}.tar.gz"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="Sympow-BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# Pari is used at build time to generate data.
BDEPEND="sys-apps/help2man
	sci-mathematics/pari"
DEPEND=""
RDEPEND="sci-mathematics/pari"

PATCHES=(
	"${FILESDIR}/${P}-dont-force-O3.patch"
	"${FILESDIR}/${P}-no-pkgdatafilesbindir-warnings.patch"
)

DOCS=( HISTORY README.md )

src_configure() {
	export ADDBINPATH=yes
	export PREFIX="${EPREFIX}/usr"

	# This location still won't be writable, but we can at least add
	# the EPREFIX that belongs there. Sympow uses $HOME/.sympow as a
	# fallback (what we want) when its first attempt doesn't work.
	export VARPREFIX="${EPREFIX}/var"

	./Configure || die
}

src_compile() {
	emake CC="$(tc-getCC)" all
}
