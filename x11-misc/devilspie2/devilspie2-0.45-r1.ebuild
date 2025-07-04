# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )
inherit lua-single plocale toolchain-funcs

DESCRIPTION="Window matching utility with Lua scripting"
HOMEPAGE="https://www.nongnu.org/devilspie2/"
SRC_URI="mirror://nongnu/${PN}/${P/-/_}-src.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	dev-libs/glib:2
	x11-libs/gtk+:3[X]
	x11-libs/libX11
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libwnck:3
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

src_compile() {
	tc-export CC PKG_CONFIG

	local PLOCALES="fi fr it ja nl pt_BR ru sv"

	DEVILSPIE2_ARGS=(
		PREFIX="${EPREFIX}"/usr
		LANGUAGES="$(plocale_get_locales)"
		LUA="${ELUA}"
	)

	emake "${DEVILSPIE2_ARGS[@]}"
}

src_install() {
	emake DESTDIR="${D}" "${DEVILSPIE2_ARGS[@]}" install
	einstalldocs

	dodoc -r doc/examples
}
