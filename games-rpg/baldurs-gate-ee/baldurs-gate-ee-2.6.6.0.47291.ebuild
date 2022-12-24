# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker wrapper

DESCRIPTION="Baldur's Gate: Enhanced Edition"
HOMEPAGE="https://baldursgate.beamdog.com/"
SRC_URI="baldur_s_gate_enhanced_edition_${PV//./_}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist fetch"

RDEPEND="dev-libs/expat
	dev-libs/openssl-compat
	media-libs/openal
	virtual/opengl
	x11-libs/libX11"
BDEPEND="app-arch/unzip"

QA_PRESTRIPPED="opt/${PN}/BaldursGate"

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
	fperms +x "${dir}/BaldursGate"

	make_wrapper ${PN} "./BaldursGate" "${dir}"

	newicon "support/icon.png" "${PN}.png"
	make_desktop_entry "${PN}" "Baldur's Gate: Enhanced Edition" "${PN}"
}
