# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop flag-o-matic toolchain-funcs

DESCRIPTION="FreeDoko is a Doppelkopf-game"
HOMEPAGE="https://free-doko.sourceforge.net"
SRC_URI="
	mirror://sourceforge/free-doko/FreeDoko_${PV}.src.zip
	backgrounds? ( mirror://sourceforge/free-doko/backgrounds.zip -> ${PN}-backgrounds.zip )
	gnomecards? ( mirror://sourceforge/free-doko/gnome-games.zip )
	kdecards? ( mirror://sourceforge/free-doko/kdecarddecks.zip )
	openclipartcards? ( mirror://sourceforge/free-doko/openclipart.zip )
	pysolcards? ( mirror://sourceforge/free-doko/pysol.zip )
	xskatcards? ( mirror://sourceforge/free-doko/xskat.zip )
	!xskatcards? (
		!kdecards? (
			!gnomecards? (
				!openclipartcards? (
					!pysolcards? (
						mirror://sourceforge/free-doko/xskat.zip ) ) ) ) )"
S="${WORKDIR}/FreeDoko_${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+backgrounds +gnomecards +kdecards +openclipartcards +pysolcards +xskatcards"

RDEPEND="
	dev-cpp/gtkmm:3.0
	media-libs/openal"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/unzip
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.8.0-gentoo.patch
)

src_unpack() {
	unpack FreeDoko_${PV}.src.zip

	local cards=
	unpack_cards() {
		if use $1; then
			cards=y
			unpack $2
		fi
	}

	cd "${S}"/data/cardsets || die

	unpack_cards gnomecards       gnome-games.zip
	unpack_cards kdecards         kdecarddecks.zip
	unpack_cards openclipartcards openclipart.zip
	unpack_cards pysolcards       pysol.zip
	unpack_cards xskatcards       xskat.zip
	[[ $cards ]] || unpack xskat.zip # fall back to xskat

	if use backgrounds ; then
		cd "${S}"/data/backgrounds || die
		unpack ${PN}-backgrounds.zip
	fi
}

src_compile() {
	tc-export CXX
	append-cppflags \
		-DPUBLIC_DATA_DIRECTORY_VALUE="'\"${EPREFIX}/usr/share/${PN}\"'" \
		-DMANUAL_DIRECTORY_VALUE="'\"${EPREFIX}/usr/share/doc/${PF}/html\"'"
	touch src/Makefile.local || die # needed for above paths to be used

	export OSTYPE=Linux
	export USE_NETWORK=false
	export USE_SOUND_ALUT=false # still marked experimental
	export VARTEXFONTS="${T}/fonts" #652028

	emake Version
	emake -C src FreeDoko LIBS="${LDFLAGS}"
}

src_install() {
	newbin src/FreeDoko freedoko

	insinto /usr/share/${PN}
	doins -r data/{backgrounds,cardsets,iconsets,sounds,*.png}

	newicon src/icon.png ${PN}.png
	make_desktop_entry ${PN} FreeDoko

	einstalldocs

	find "${ED}"/usr/share/${PN} -name Makefile -delete || die
}
