# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHECKREQS_DISK_BUILD="1463M"
CHECKREQS_DISK_USR="1461M"
inherit check-reqs

DESCRIPTION="High definition backgrounds and sprites for The Longest Journey"
HOMEPAGE="https://tljhd.github.io"
SRC_URI="TLJHD_${PV}.zip"
LICENSE="fairuse"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist fetch"

RDEPEND="
	${CATEGORY}/${PN%-hd}
"

BDEPEND="
	app-arch/unzip
"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your distfiles directory."
}

src_install() {
	insinto /usr/share/${PN%-hd}
	# The fonts are the same as the original ones.
	doins -r mods/
}
