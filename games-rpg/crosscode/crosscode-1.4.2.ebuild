# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHECKREQS_DISK_BUILD="767M"
inherit check-reqs desktop wrapper xdg

DESCRIPTION="Retro-inspired 2D Action RPG with a sci-fi story"
HOMEPAGE="https://radicalfishgames.itch.io/crosscode"
SRC_URI="crosscode-new-linux64.zip"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist fetch splitdebug"

RDEPEND="
	>=dev-libs/nwjs-0.62.1
"

BDEPEND="
	app-arch/unzip
"

S="${WORKDIR}"
DIR="/usr/share/${PN}"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your distfiles directory."
}

src_prepare() {
	default

	# Greenworks is only needed under Steam.
	rm -r assets/modules/ || die
}

src_install() {
	insinto "${DIR}"
	doins -r assets/ favicon.png natives_blob.bin package.json

	newicon assets/media/face/lore/lea.png ${PN}.png
	make_wrapper ${PN} "nwjs '${EPREFIX}${DIR}'"
	make_desktop_entry ${PN} CrossCode
}
