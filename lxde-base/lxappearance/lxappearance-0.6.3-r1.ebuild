# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="ar be bg ca cs da de el en_GB es et eu fa fi fo fr gl he hr hu id is
it ja kk ko lg lt nl pa pl pt_BR pt ro ru sl sr@latin sr sv te tr tt_RU ug uk
ur_PK ur vi zh_CN zh_TW"

PLOCALE_BACKUP="en_GB"

inherit l10n

DESCRIPTION="LXDE GTK+ theme switcher"
HOMEPAGE="https://wiki.lxde.org/en/LXAppearance"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~mips ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="dbus"

RDEPEND="x11-libs/gtk+:2
	dbus? ( dev-libs/dbus-glib )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext"

src_prepare() {
	default

	export LINGUAS="${LINGUAS:-${PLOCALE_BACKUP}}"
	l10n_get_locales > po/LINGUAS || die
}

src_configure() {
	econf \
		$(use_enable dbus)
}
