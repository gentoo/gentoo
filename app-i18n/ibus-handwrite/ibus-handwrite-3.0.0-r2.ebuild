# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Hand write recognition/input for IBus"
HOMEPAGE="https://github.com/microcai/ibus-handwrite"
SRC_URI="https://github.com/microcai/${PN}/releases/download/${PV%.0}/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls +zinnia"

RDEPEND="app-i18n/ibus
	x11-libs/gtk+:3
	nls? ( virtual/libintl )
	zinnia? (
		app-i18n/zinnia
		app-i18n/zinnia-tomoe
	)"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${PN}-blink.patch
	"${FILESDIR}"/${PN}-headers.patch
	"${FILESDIR}"/${PN}-nested-function.patch
	"${FILESDIR}"/${P}-fix-compile.patch
)

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable zinnia) \
		$(use_with zinnia zinnia-tomoe "${EPREFIX}"/usr/$(get_libdir)/zinnia/model/tomoe)
}
