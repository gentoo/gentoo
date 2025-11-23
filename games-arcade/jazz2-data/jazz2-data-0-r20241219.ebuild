# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit estack

DESCRIPTION="Jazz Jackrabbit 2 data files for games-arcade/jazz2"
HOMEPAGE="https://www.gog.com/game/jazz_jackrabbit_2_collection"

# Order is significant!
SRC_URI="
	demo? (
		https://deat.tk/jazz2/misc/shareware-demo.zip -> jazz2-shareware-demo.zip
	)
	!demo? (
		setup_jazz_jackrabbit_2_1.24hf_(16886).exe
		cc? ( setup_jazz_jackrabbit_2_cc_1.2x_(16742).exe )
	)
"

S="${WORKDIR}/app"
LICENSE="free-noncomm GOG-EULA"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+cc demo"
RESTRICT="!demo? ( bindist fetch )"

RDEPEND=">=games-arcade/jazz2-3.0.0-r1"

BDEPEND="
	demo? ( app-arch/unzip )
	!demo? ( app-arch/innoextract )
"

DIR="/usr/share/jazz2"

pkg_nofetch() {
	einfo "Please buy and download the following files from"
	einfo "${HOMEPAGE}."
	einfo
	local EXE
	for EXE in ${A}; do
		einfo " - ${EXE}"
	done
}

src_unpack() {
	if use demo; then
		unzip -qoL -d app "${DISTDIR}/${A}" || die
	else
		local EXE
		for EXE in ${A}; do
			innoextract -e -s -p0 -L -I app "${DISTDIR}/${EXE}" || die
		done
	fi
}

src_install() {
	eshopts_push -s nullglob
	insinto /usr/share/jazz2/Source
	doins -r *.j?? *.it *.mod *.s3m tiles*/
	eshopts_pop
}
