# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} luajit )
PLOCALES="fi fr it ja nl pt_BR ru sv"

inherit lua-single toolchain-funcs l10n

DESCRIPTION="Devilspie like window matching utility, using LUA for scripting"
HOMEPAGE="https://www.nongnu.org/devilspie2/"
SRC_URI="https://download.savannah.gnu.org/releases/devilspie2/devilspie2_${PV}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	>=dev-libs/glib-2.32.4:2
	>=x11-libs/gtk+-3.4.4:3
	>=x11-libs/libwnck-3.4.4:3
	x11-libs/libX11
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-0.43-lua-pkgconfig.patch"
)

src_compile() {
	tc-export PKG_CONFIG
	emake CC="$(tc-getCC)" PREFIX="/usr" LANGUAGES="$(l10n_get_locales)"
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${ED}" LANGUAGES="$(l10n_get_locales)" install
	einstalldocs
	doman devilspie2.1
}
