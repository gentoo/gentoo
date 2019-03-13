# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils unpacker

DESCRIPTION="Baldur's Gate: Enhanced Edition"
HOMEPAGE="https://www.baldursgate.com/"
SRC_URI="baldur_s_gate_enhanced_edition_en_${PV//./_}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist fetch"

DEPEND="app-arch/unzip"
RDEPEND="dev-libs/expat
	dev-libs/openssl:0
	media-libs/openal
	virtual/opengl
	x11-libs/libX11"

QA_PRESTRIPPED="/opt/${PN}/BaldursGate\(64\)\?"

S="${WORKDIR}/data/noarch"

pkg_nofetch() {
	einfo "Please buy and download \"${SRC_URI}\" from"
	einfo "https://www.gog.com/game/baldurs_gate_enhanced_edition"
	einfo "and place it in your DISTDIR directory."
}

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	local dir="/opt/${PN}"

	dodoc -r "game/Manuals/."
	rm -r "game/Manuals" || die "rm failed"

	insinto "${dir}"
	doins -r "game/."
	fperms +x "${dir}/BaldursGate"{,64}

	use amd64 && make_wrapper ${PN} "./BaldursGate64" "${dir}"
	use x86 && make_wrapper ${PN} "./BaldursGate" "${dir}"

	newicon "support/icon.png" "${PN}.png"
	make_desktop_entry "${PN}" "Baldur's Gate: Enhanced Edition" "${PN}"
}
