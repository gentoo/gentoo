# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils toolchain-funcs flag-o-matic

DESCRIPTION="A precise PDF to HTML converter"
HOMEPAGE="http://coolwanglu.github.io/pdf2htmlEX/"
SRC_URI="
	https://github.com/coolwanglu/${PN}/archive/v${PV}.tar.gz -> ${P}.tgz
	https://dev.gentoo.org/~dilfrigde/distfiles/${P}.tgz
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

CDEPEND="
	>=app-text/poppler-0.61.1:=[jpeg,png]
	app-text/poppler-data
	media-gfx/fontforge
	media-libs/freetype
	x11-libs/cairo[svg]
"
RDEPEND="${CDEPEND}
"
DEPEND="${CDEPEND}
	virtual/pkgconfig
"

pkg_pretend() {
	local ver=6.4.0
	local msg="${P} needs at least GCC ${ver} set to compile."
	if [[ ${MERGE_TYPE} != binary ]]; then
		if ! version_is_at_least ${ver} $(gcc-fullversion); then
			die ${msg}
		fi
	fi
}

src_configure() {
	append-cflags -no-pie
	append-cxxflags -no-pie
	cmake-utils_src_configure
}
