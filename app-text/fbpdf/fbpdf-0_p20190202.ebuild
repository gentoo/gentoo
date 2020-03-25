# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs vcs-snapshot

COMMIT="dfe9f0067549f759cdc04f2f62b4f89cd6e1b199"

DESCRIPTION="framebuffer pdf and djvu viewer"
HOMEPAGE="https://github.com/aligrudi/fbpdf"

SRC_URI="https://github.com/aligrudi/fbpdf/archive/${COMMIT}.tar.gz -> ${P}-${COMMIT}.tar.gz"

LICENSE="BSD ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=app-text/mupdf-1.10:0=
	app-text/djvu:0=
	dev-lang/mujs:0=
	dev-libs/openssl:0=
	!media-gfx/fbida[fbcon(-)]
	media-libs/freetype:2=
	media-libs/jbig2dec:0=
	media-libs/openjpeg:0=
	virtual/jpeg:0=
"

DEPEND="${RDEPEND}"

S=${WORKDIR}/${P}-${COMMIT}

PATCHES=(
	"${FILESDIR}"/${P}-use-pkg-config.patch
	"${FILESDIR}"/${P}-printf.patch
)

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin fbpdf fbdjvu
	dodoc README
}
