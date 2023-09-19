# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit plocale toolchain-funcs

DESCRIPTION="Clone of a C64 game - destroy the opponent's house"
HOMEPAGE="https://github.com/kouya/tornado"
SRC_URI="https://github.com/kouya/tornado/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	acct-group/gamestat
	sys-libs/ncurses:=
	virtual/libintl"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${P}-make.patch
)

src_prepare() {
	default

	sed -i "/SCOREFILE_NAME/s|/|${EPREFIX}/|" scores.h || die
}

src_compile() {
	tc-export CC PKG_CONFIG

	emake PREFIX="${EPREFIX}/usr" LOCALEPATH="${EPREFIX}/usr/share/locale"
}

src_install() {
	dobin tornado
	doman doc/man/tornado.6

	einstalldocs

	tornado_man() {
		doman -i18n=${1} doc/man/${1}/${PN}.6
	}
	local PLOCALES="de fr it nl no ru"
	plocale_for_each_locale tornado_man

	PLOCALES+=" es pt"
	local mo=($(plocale_get_locales))
	mo=("${mo[@]/%/.mo}")
	(( ${#mo[@]} )) && domo "${mo[@]/#/po/}"

	insinto /var/games
	doins ${PN}.scores

	fowners :gamestat /usr/bin/${PN} /var/games/${PN}.scores
	fperms g+s /usr/bin/${PN}
	fperms 660 /var/games/${PN}.scores
}
