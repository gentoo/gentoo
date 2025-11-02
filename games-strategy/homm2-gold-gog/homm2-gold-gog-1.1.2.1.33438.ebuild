# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Data files for HoMM II Gold from gog.com"
HOMEPAGE="https://www.gog.com/en/game/heroes_of_might_and_magic_2_gold_edition"
SRC_URI="
	setup_heroes_of_might_and_magic_2_gold_1.01_(2.1)_(33438).exe
	flac? ( homm_2_ost_flac.zip )
"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="flac"
RESTRICT="bindist fetch"

DEPEND="games-engines/fheroes2"
RDEPEND="
	${DEPEND}
	!games-strategy/homm2-demo
"
BDEPEND="
	app-arch/innoextract
	flac? ( app-arch/unzip )
"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your distfiles directory."
}

src_install() {
	mkdir -p "${ED}/usr/share/fheroes2/" || die
	"${ESYSROOT}"/usr/share/fheroes2/extract_homm2_resources.sh \
		"${DISTDIR}"/setup_heroes*.exe \
		"${ED}/usr/share/fheroes2/" || die
	chmod -R a+r "${ED}/usr/share/fheroes2/anim" || die

	if use flac; then
		rm -r "${ED}/usr/share/fheroes2/music" || die
		cd homm_2_ost_flac || die
		# This abomination is loosely based on
		# https://github.com/ihhub/fheroes2/blob/48c4740e9349c04209a204b9627ebd174a5051e5/script/homm2/resource_extraction_toolset.ps1#L52
		for ((i=1; i<=43; i++)); do
			local ii="$(printf "%.2d" "${i}")"
			local filename="$(echo *${ii}*)"
			local extension="${filename##*.}"
			if ((i>=5 && i<=10)); then
				insinto /usr/share/fheroes2/music/sw
				newins "${filename}" "Track${ii}.${extension}"

				local pol=$((i+39))
				local polfile=$(echo *${pol}*)
				local polext="${polfile##*.}"
				insinto /usr/share/fheroes2/music/pol
				newins "${polfile}" "Track${ii}.${polext}"
			else
				insinto /usr/share/fheroes2/music
				newins "${filename}" "Track${ii}.${extension}"
			fi
		done
		cp "${ED}"/usr/share/fheroes2/music/pol/* "${ED}"/usr/share/fheroes2/music/ || die
	fi
}

pkg_postinst() {
	elog "Run the game using ${EPREFIX}/usr/bin/fheroes2"
}
