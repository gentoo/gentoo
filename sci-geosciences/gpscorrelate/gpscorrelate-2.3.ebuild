# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs xdg

DESCRIPTION="Tool for adjusting EXIF tags of your photos with a recorded GPS trace"
HOMEPAGE="https://dfandrich.github.io/gpscorrelate/"
SRC_URI="https://github.com/dfandrich/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="gtk"

RDEPEND="
	dev-libs/libxml2:=
	media-gfx/exiv2:=
	gtk? (
		app-accessibility/at-spi2-core:2
		dev-libs/glib:2
		media-libs/harfbuzz:=
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3
		x11-libs/pango
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${P}-adapt_makefile.patch"
)

src_compile() {
	export prefix="${EPREFIX}/usr"
	export docdir="${prefix}/share/doc/${PF}/html"
	export TARGETS="$(usex gtk 'gpscorrelate gpscorrelate-gui' 'gpscorrelate')"
	local emakeargs=(
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		PKG_CONFIG="$(tc-getPKG_CONFIG)"
	)
	emake "${emakeargs[@]}"
}

src_install() {
	for file in po/*.po; do
		msgfmt "${file}" -o "${file%.po}.mo" && domo "${file%.po}.mo" || die
	done

	default
}
