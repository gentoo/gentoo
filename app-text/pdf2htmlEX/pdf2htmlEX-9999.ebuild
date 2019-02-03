# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils toolchain-funcs flag-o-matic versionator

DESCRIPTION="A precise PDF to HTML converter (dilfridge fork)"
HOMEPAGE="https://github.com/akhuettel/pdf2htmlEX"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/akhuettel/pdf2htmlEX.git"
else
	SRC_URI="https://dev.gentoo.org/~dilfridge/distfiles/${P}.tar.xz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE=""

CDEPEND="
	>=app-text/poppler-0.61.1:=[jpeg,png]
	app-text/poppler-data
	~media-gfx/fontforge-20170731[cairo,png]
	media-libs/freetype
	x11-libs/cairo[svg]
"
RDEPEND="${CDEPEND}
"
DEPEND="${CDEPEND}
	virtual/pkgconfig
	virtual/jre
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
	append-cxxflags -no-pie -fpermissive
	cmake-utils_src_configure
}
