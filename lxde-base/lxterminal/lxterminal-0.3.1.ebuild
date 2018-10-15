# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="af ar be bg bn bn_IN ca cs da de el en_GB eo es et eu fa fi fo fr frp gl
he hr hu id is it ja kk ko lg lt ml ms nb nl nn pa pl ps pt pt_BR ro ru sk sl sr
sr@latin sv te th tr tt_RU ug uk ur ur_PK vi zh_CN zh_TW"
PLOCALE_BACKUP="en_GB"

inherit autotools l10n

DESCRIPTION="Lightweight vte-based tabbed terminal emulator for LXDE"
HOMEPAGE="https://wiki.lxde.org/en/LXTerminal"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://git.code.sf.net/p/lxde/${PN}"
	inherit git-r3
	KEYWORDS="amd64 arm ppc x86"
else
	SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"
	KEYWORDS="~alpha amd64 arm ~arm64 ~mips ppc x86 ~amd64-linux ~x86-linux"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="gtk3"

RDEPEND="dev-libs/glib:2
	!gtk3? ( x11-libs/gtk+:2 x11-libs/vte:0 )
	gtk3?  ( x11-libs/gtk+:3 x11-libs/vte:2.91 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext
	>=dev-util/intltool-0.40.0"

src_prepare() {
	default
	eautoreconf

	export LINGUAS="${LINGUAS:-${PLOCALE_BACKUP}}"
	l10n_get_locales > po/LINGUAS || die
}

src_configure() {
	econf --enable-man $(use_enable gtk3)
}

pkg_postinst() {

	elog "If you happen to get broken output of"
	elog "ncurses based apps, such as htop, try"
	elog "to set TERM=vte via your .bashrc"
}
