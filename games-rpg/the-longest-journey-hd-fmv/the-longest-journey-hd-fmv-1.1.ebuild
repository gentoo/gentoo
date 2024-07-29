# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHECKREQS_DISK_BUILD="3229M"
CHECKREQS_DISK_USR="3229M"
inherit check-reqs

DESCRIPTION="Upscaled full motion videos for The Longest Journey"
HOMEPAGE="https://tljhd.github.io"
SRC_URI="TLJHD_FMV_${PV}.zip"
LICENSE="fairuse"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist fetch"

RDEPEND="
	${CATEGORY}/${PN%-hd-fmv}
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
	insinto /usr/share/${PN%-hd-fmv}
	doins -r mods/
}
