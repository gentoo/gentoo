# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Feature rich terminal emulator using the Enlightenment Foundation Libraries"
HOMEPAGE="https://www.enlightenment.org/about-terminology"
SRC_URI="https://fau.re/${PN}/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 x86"
IUSE="nls"

RDEPEND="
	|| ( dev-libs/efl[egl] dev-libs/efl[opengl] )
	|| ( dev-libs/efl[X] dev-libs/efl[wayland] )
	app-arch/lz4
	dev-libs/efl[eet,fontconfig]
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

src_configure() {
	local emesonargs=(
		$(meson_use nls)
	)

	meson_src_configure
}
