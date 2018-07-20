# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils games

DESCRIPTION="A port of Jagged Alliance 2 to SDL"
HOMEPAGE="https://ja2-stracciatella.github.io/"
SRC_URI="https://dev.gentoo.org/~hasufell/distfiles/${P}.tar.xz
	http://tron.homeunix.org/ja2/editor.slf.gz"

LICENSE="SFI-SCLA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cdinstall editor ru-gold zlib"

DEPEND="media-libs/libsdl[X,sound,video]
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}
	cdinstall? ( games-strategy/ja2-stracciatella-data )"

LANGS="l10n_de +l10n_en l10n_fr l10n_it l10n_nl l10n_pl l10n_ru"
IUSE="$IUSE $LANGS"
REQUIRED_USE="^^ ( ${LANGS//+/} )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
	epatch "${FILESDIR}"/${P}-gcc6.patch

	sed \
		-e "s:/some/place/where/the/data/is:${GAMES_DATADIR}/ja2:" \
		-i sgp/FileMan.cc || die

	sed \
		-e "s:@GAMES_DATADIR@:${GAMES_DATADIR}/ja2/data:" \
		"${FILESDIR}"/ja2-convert.sh > "${T}"/ja2-convert || die
}

src_compile() {
	local myconf

	case ${L10N} in
		de) myconf="LNG=GERMAN" ;;
		nl) myconf="LNG=DUTCH" ;;
		fr) myconf="LNG=FRENCH" ;;
		it) myconf="LNG=ITALIAN" ;;
		pl) myconf="LNG=POLISH" ;;
		ru) myconf="LNG=$(usex ru-gold RUSSIAN_GOLD RUSSIAN)" ;;
		en) myconf="LNG=ENGLISH" ;;
		*) die "wat" ;;
	esac
	elog "Chosen language is ${myconf#LNG=}"

	use editor && myconf+=" JA2EDITOR=yes JA2BETAVERSION=yes"
	use zlib && myconf+=" WITH_ZLIB=yes"

	emake ${myconf}
}

src_install() {
	dogamesbin ja2 "${T}"/ja2-convert

	if use editor; then
		insinto "${GAMES_DATADIR}"/ja2/data
		doins "${WORKDIR}"/editor.slf
	fi

	make_desktop_entry ja2 ${PN}
	doman ja2.6

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "You need ja2 in the chosen language, otherwise set it in package.use!"

	if ! use cdinstall ; then
		elog "You need to copy all files from the Data directory of"
		elog "Jagged Alliance 2 installation to"
		elog "${GAMES_DATADIR}/ja2/data "
		elog "Make sure the filenames are lowercase. You may want to run the"
		elog "script":
		elog "${GAMES_BINDIR}/ja2-convert"
	fi
}
