# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop unpacker wrapper

DESCRIPTION="Baldur's Gate: Enhanced Edition"
HOMEPAGE="https://www.baldursgate.com/"
SRC_URI="gog_baldur_s_gate_enhanced_edition_2.5.0.9.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist fetch"

DEPEND="app-arch/unzip"
RDEPEND="dev-libs/expat[abi_x86_32(-)]
	dev-libs/json-c[abi_x86_32(-)]
	dev-libs/openssl:0[abi_x86_32(-)]
	media-libs/openal[abi_x86_32(-)]
	virtual/opengl[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]"

QA_PREBUILT="/opt/${PN}/BaldursGate"

S="${WORKDIR}/data/noarch"

pkg_nofetch() {
	einfo "Please buy and download \"${SRC_URI}\" from"
	einfo "https://www.gog.com/game/baldurs_gate_enhanced_edition"
	einfo "and copy it into your DISTDIR directory."
}

src_unpack() {
	unpack_zip "${DISTDIR}/${SRC_URI}"
}

src_install() {
	local ABI="x86"
	local dir="/opt/${PN}"

	dodoc -r "game/Manuals/."
	rm -r "game/Manuals" || die "rm failed"

	insinto "${dir}"
	doins -r "game/."
	fperms +x "${dir}/BaldursGate"

	dodir "${dir}/lib"
	dosym "../../../usr/$(get_libdir)/libjson-c.so" "${dir}/lib/libjson.so.0"

	newicon "support/icon.png" "${PN}.png"
	make_wrapper ${PN} "./BaldursGate" "${dir}" "${dir}/lib"
	make_desktop_entry "${PN}" "Baldur's Gate: Enhanced Edition" "${PN}" "Game;RolePlaying"
}
