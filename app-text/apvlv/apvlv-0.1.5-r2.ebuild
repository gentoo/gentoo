# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg cmake desktop

DESCRIPTION="Alf's PDF Viewer Like Vim"
HOMEPAGE="https://naihe2010.github.com/apvlv/"
SRC_URI="https://github.com/naihe2010/apvlv/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug djvu"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	>=app-text/poppler-0.18[cairo,xpdf-headers(+)]
	dev-libs/glib:2
	x11-libs/gtk+:3
	djvu? ( app-text/djvu:= )
"
RDEPEND="${DEPEND}"

PATCHES=(
	# preserve cflags
	"${FILESDIR}/${P}-cflags.patch"
	"${FILESDIR}/${P}-gcc6.patch"
	"${FILESDIR}/${P}-gcc7.patch"
	"${FILESDIR}/${P}-poppler-0.73.patch"
)

src_configure() {
	local mycmakeargs=(
		-DSYSCONFDIR=/etc/${PN}
		-DDOCDIR=/usr/share/${PN}
		-DMANDIR=/usr/share/man
		-DAPVLV_WITH_HTML=OFF
		-DAPVLV_WITH_UMD=OFF
		-DAPVLV_WITH_TXT=ON
		-DAPVLV_WITH_DJVU=$(usex djvu)
		-DAPVLV_ENABLE_DEBUG=$(usex debug)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	newicon -s 32 icons/pdf.png ${PN}.png
}
