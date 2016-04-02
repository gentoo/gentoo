# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic gnome2-utils games

DESCRIPTION="FreeDoko is a Doppelkopf-game"
HOMEPAGE="http://free-doko.sourceforge.net"
SRC_URI="mirror://sourceforge/free-doko/FreeDoko_${PV}.src.zip
	backgrounds? ( mirror://sourceforge/free-doko/backgrounds.zip -> ${PN}-backgrounds.zip )
	kdecards? ( mirror://sourceforge/free-doko/kdecarddecks.zip )
	xskatcards? ( mirror://sourceforge/free-doko/xskat.zip )
	pysolcards? ( mirror://sourceforge/free-doko/pysol.zip )
	gnomecards? ( mirror://sourceforge/free-doko/gnome-games.zip )
	openclipartcards? ( mirror://sourceforge/free-doko/openclipart.zip )
	!xskatcards? (
		!kdecards? (
			!gnomecards? (
				!openclipartcards? (
					!pysolcards? (
						mirror://sourceforge/free-doko/xskat.zip ) ) ) ) )"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+xskatcards +gnomecards +kdecards +openclipartcards +pysolcards +backgrounds net"

RDEPEND="net? ( net-libs/gnet dev-libs/glib:2 )
	>=dev-cpp/gtkmm-2.4:2.4"
DEPEND="${RDEPEND}
	app-arch/unzip
	virtual/pkgconfig"

S=${WORKDIR}/FreeDoko_${PV}

src_unpack() {
	local cards=0

	unpack_cards() {
		use $1 && { unpack $2 ; cards=$(( $cards + 1 )); };
	}
	unpack FreeDoko_${PV}.src.zip
	cp /dev/null "${S}"/src/Makefile.local || die

	cd "${S}"/data/cardsets || die

	unpack_cards xskatcards       xskat.zip
	unpack_cards kdecards         kdecarddecks.zip
	unpack_cards pysolcards       pysol.zip
	unpack_cards gnomecards       gnome-games.zip
	unpack_cards openclipartcards openclipart.zip
	[ $cards ] || unpack xskat.zip # fall back to xskat

	if use backgrounds ; then
		cd "${S}"/data/backgrounds || die
		unpack ${PN}-backgrounds.zip
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	append-cxxflags -std=c++11
}

src_compile() {
	export CPPFLAGS="-DPUBLIC_DATA_DIRECTORY_VALUE='\"${GAMES_DATADIR}/${PN}\"'"
	export CPPFLAGS+=" -DMANUAL_DIRECTORY_VALUE='\"/usr/share/doc/${PF}/html\"'"
	export OSTYPE=Linux
	export USE_NETWORK=$(use net && echo true || echo false)
	export USE_SOUND_ALUT=false # still marked experimental
	emake Version
	emake -C src FreeDoko
}

src_install() {
	newgamesbin src/FreeDoko freedoko
	insinto "${GAMES_DATADIR}"/${PN}/
	doins -r data/{backgrounds,cardsets,iconsets,rules,sounds,translations,*png}
	find "${D}${GAMES_DATADIR}"/${PN} -name Makefile -delete
	dodoc AUTHORS README ChangeLog
	newicon -s 32 src/FreeDoko.png ${PN}.png
	make_desktop_entry ${PN} FreeDoko
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
