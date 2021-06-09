# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop flag-o-matic toolchain-funcs xdg

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
KEYWORDS="~amd64 ~x86"
IUSE="+xskatcards +gnomecards +kdecards +openclipartcards +pysolcards +backgrounds"

RDEPEND="dev-cpp/gtkmm:3.0
	media-libs/openal"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip
	virtual/pkgconfig"

S="${WORKDIR}/FreeDoko_${PV}"

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

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.16-gentoo.patch
)

src_compile() {
	tc-export CXX
	append-cxxflags -std=c++14
	append-cppflags -DPUBLIC_DATA_DIRECTORY_VALUE="'\"${EPREFIX}/usr/share/${PN}\"'" \
		-DMANUAL_DIRECTORY_VALUE="'\"${EPREFIX}/usr/share/doc/${PF}/html\"'"

	export VARTEXFONTS="${T}/fonts" #652028
	export OSTYPE=Linux
	export USE_NETWORK=false
	export USE_SOUND_ALUT=false # still marked experimental

	emake Version
	emake -C src FreeDoko LIBS="${LDFLAGS}"
}

src_install() {
	newbin src/FreeDoko freedoko

	insinto /usr/share/${PN}/
	doins -r data/{backgrounds,cardsets,iconsets,rules,sounds,translations,*png}

	newicon -s 32 src/FreeDoko.png ${PN}.png
	make_desktop_entry ${PN} FreeDoko

	einstalldocs

	find "${ED}/usr/share/${PN}" -name Makefile -delete || die
}
