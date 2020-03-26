# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DEATTK="http://deat.tk/jazz2/misc"
JJ2PLUS="${DEATTK}/jj2plus-v1.zip"

DESCRIPTION="Jazz Jackrabbit 2 data files imported for games-arcade/jazz2"
HOMEPAGE="https://www.gog.com/game/jazz_jackrabbit_2_collection"

# Order is significant!
SRC_URI="
	${JJ2PLUS}
	demo? (
		${DEATTK}/shareware-demo.zip -> jazz2-shareware-demo.zip
	)
	!demo? (
		cc? ( setup_jazz_jackrabbit_2_cc_1.2x_(16742).exe )
		setup_jazz_jackrabbit_2_1.24hf_(16886).exe
	)
"

LICENSE="free-noncomm GOG-EULA"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+cc demo gles2-only"
RESTRICT="!demo? ( bindist fetch )"

RDEPEND="games-arcade/jazz2:=[gles2-only=]"

DEPEND="
	${RDEPEND}
	!demo? ( app-arch/innoextract )
"

DIR="/usr/share/jazz2"
S="${WORKDIR}"

pkg_nofetch() {
	local a
	einfo "Please place the following files in your distfiles directory."
	einfo
	einfo "  Go to https://www.gog.com/game/jazz_jackrabbit_2_collection,"
	einfo "  purchase the game, and download:"
	for a in ${A}; do
		[[ ${SRC_URI} == */${a}* ]] && continue
		einfo "    - ${a}"
	done
	einfo
	einfo "  You must also download:"
	einfo "    - ${JJ2PLUS}"
}

src_unpack() {
	ln -snf "${DISTDIR}/${JJ2PLUS##*/}" || die

	if use demo; then
		ln -snf "${DISTDIR}"/jazz2-shareware-demo.zip shareware-demo.zip || die
	else
		local EXE
		for EXE in ${A}; do
			[[ ${EXE} == *.exe ]] || continue
			innoextract -e -s -p0 -I app -d "${EXE}" "${DISTDIR}/${EXE}" || die
		done
	fi
}

src_install() {
	if use demo; then
		jazz2-import /no-wait /output "${ED}${DIR}" || die
	else
		local EXE
		for EXE in ${A}; do
			[[ ${EXE} == *.exe ]] || continue
			jazz2-import /no-wait /output "${ED}${DIR}" "${EXE}"/app || die
		done
	fi
}
