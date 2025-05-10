# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Tool for adjusting EXIF tags of your photos with a recorded GPS trace"
HOMEPAGE="https://dfandrich.github.io/gpscorrelate/"
SRC_URI="https://github.com/dfandrich/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="gtk"

BDEPEND="
	app-text/docbook-xml-dtd:4.2
	dev-libs/libxslt
	virtual/pkgconfig
"
DEPEND="
	dev-libs/libxml2:2=
	media-gfx/exiv2:=
	gtk? ( x11-libs/gtk+:3 )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-desktop-pass-validation.patch"
	"${FILESDIR}/${P}-respect-users-flags.patch"
	"${FILESDIR}/${P}-exiv2-0.28.patch" # bug 906498
)

src_compile() {
	emake gpscorrelate
	use gtk && emake gpscorrelate-gui

}

src_install() {
	dobin ${PN}
	if use gtk; then
		dobin ${PN}-gui
		doicon -s scalable ${PN}-gui.svg
		domenu ${PN}.desktop
	fi
	dodoc doc/*.html doc/*.png doc/*.xml
	einstalldocs
	doman doc/${PN}.1
}
