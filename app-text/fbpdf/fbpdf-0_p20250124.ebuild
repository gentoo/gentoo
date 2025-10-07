# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

COMMIT_HASH="6a0d77f06f6f03085a5b786d1feb8a041318b30a"
DESCRIPTION="Framebuffer pdf and djvu viewer"
HOMEPAGE="https://github.com/aligrudi/fbpdf"
SRC_URI="https://github.com/aligrudi/fbpdf/archive/${COMMIT_HASH}.tar.gz -> ${P}-${COMMIT_HASH}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT_HASH}"

LICENSE="BSD ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="djvu poppler"

RDEPEND="
	djvu? ( app-text/djvu )
	!poppler? ( app-text/mupdf:= )
	poppler? ( app-text/poppler:=[cxx] )
	!>=media-gfx/fbida-2.14_p20241216[pdf]
	!<media-gfx/fbida-2.14_p20241216[fbcon]
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0_p20250124-use-pkg-config.patch
)

src_compile() {
	local targets=(
		$(usev djvu fbdjvu)
		$(usex poppler fbpdf2 fbpdf)
	)
	local myemakeargs=(
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		CFLAGS="${CFLAGS}"
		CXXFLAGS="${CXXFLAGS}"
		LDFLAGS="${LDFLAGS}"
		PKG_CONFIG="$(tc-getPKG_CONFIG)"
	)
	emake "${myemakeargs[@]}" "${targets[@]}"
}

src_install() {
	use djvu && dobin fbdjvu

	if use poppler; then
		dobin fbpdf2
		dosym fbpdf2 /usr/bin/fbpdf
	else
		dobin fbpdf
	fi

	dodoc README
	doman fbpdf.1
}
