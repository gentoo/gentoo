# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PLOCALES="fi fr it ja nl pt_BR ru sv"
inherit flag-o-matic toolchain-funcs l10n

DESCRIPTION="Devilspie like window matching utility, using LUA for scripting"
HOMEPAGE="https://www.nongnu.org/devilspie2/"
SRC_URI="https://download.savannah.gnu.org/releases/devilspie2/devilspie2_${PV}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-lang/lua-5.1.5:0
	>=dev-libs/glib-2.32.4:2
	>=x11-libs/gtk+-3.4.4:3
	>=x11-libs/libwnck-3.4.4:3
	x11-libs/libX11
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
DEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

src_compile() {
	emake CC=$(tc-getCC) PREFIX="/usr" LANGUAGES="$(l10n_get_locales)"
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" LANGUAGES="$(l10n_get_locales)" install

	dodoc AUTHORS ChangeLog README README.translators TODO VERSION
	doman devilspie2.1
}
