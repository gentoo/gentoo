# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A HTTP benchmarking tool"
HOMEPAGE="https://www.github.com/wg/wrk"
SRC_URI="https://www.github.com/wg/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64 x86"
LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
IUSE="libressl"

RDEPEND="
	dev-lang/lua:0
	dev-lang/luajit:2
	libressl? ( dev-libs/libressl:0= )
	!libressl? ( dev-libs/openssl:0= )
"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=(
	"CHANGES"
	"NOTICE"
	"README.md"
	"SCRIPTING"
)

PATCHES=( "${FILESDIR}/${P}-r1-makefile.patch" )

src_compile() {
	myemakeargs=(
		CC="$(tc-getCC)"
		VER="${PV}"
		WITH_LUAJIT="/usr"
		WITH_OPENSSL="/usr"
	)

	emake "${myemakeargs[@]}"
}

src_install() {
	dobin wrk

	insinto /usr/share/wrk
	doins -r scripts

	einstalldocs
}
