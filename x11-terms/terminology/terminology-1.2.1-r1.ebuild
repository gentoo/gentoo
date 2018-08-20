# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson xdg-utils

DESCRIPTION="Feature rich terminal emulator using the Enlightenment Foundation Libraries"
HOMEPAGE="https://www.enlightenment.org/about-terminology"
SRC_URI="https://download.enlightenment.org/rel/apps/${PN}/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="nls"

RDEPEND="
	|| ( dev-libs/efl[egl] dev-libs/efl[opengl] )
	|| ( dev-libs/efl[X] dev-libs/efl[wayland] )
	app-arch/lz4
	>=dev-libs/efl-1.20.0[eet,fontconfig]
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}/terminology-1.2.1-use-system-lz4.patch"
)

src_prepare() {
	default
	xdg_environment_reset
}

src_configure() {
	local emesonargs=(
		-D nls=$(usex nls true false)
	)

	meson_src_configure
}
