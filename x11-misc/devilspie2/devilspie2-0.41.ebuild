# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# check locales on version bump!
PLOCALES="fi fr it ja nl pt_BR ru sv"
inherit flag-o-matic toolchain-funcs l10n

DESCRIPTION="Devilspie like window matching utility, using LUA for scripting"
HOMEPAGE="http://gusnan.se/devilspie2"
SRC_URI="http://download.savannah.gnu.org/releases/devilspie2/devilspie2_${PV}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND=">=dev-libs/glib-2.32.4:2
	>=dev-lang/lua-5.1.5:0
	>=x11-libs/gtk+-3.4.4:3
	>=x11-libs/libwnck-3.4.4:3
	x11-libs/libX11"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	x11-proto/xproto"

src_prepare() {
	use debug && append-cflags -D_DEBUG
}

src_compile() {
	emake CC=$(tc-getCC) PREFIX="/usr" LANGUAGES="$(l10n_get_locales)"
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" LANGUAGES="$(l10n_get_locales)" install

	dodoc AUTHORS ChangeLog README README.translators TODO VERSION
	doman devilspie2.1
}

pkg_postinst() {
	elog "Default directory for scripts is ~/.config/devilspie2/"
}
