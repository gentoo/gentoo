# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHECKREQS_DISK_BUILD="30583M"
inherit check-reqs desktop xdg

MY_P="Psychonauts2_${PV}"
MY_PN="${PN%-hb}"
DESCRIPTION="Platform-adventure game with cinematic style and customizable psychic powers"
HOMEPAGE="https://www.humblebundle.com/store/psychonauts-2"
SRC_URI="${MY_P}.tar.xz
	mirror+https://dev.gentoo.org/~chewi/distfiles/${MY_PN}.png"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist fetch splitdebug"

RDEPEND="
	>=sys-libs/glibc-2.17
	x11-misc/xdg-user-dirs
	!${CATEGORY}/${MY_PN}-gog
"

S="${WORKDIR}/${MY_P}"
DIR="/opt/${MY_PN}"
QA_PREBUILT="${DIR#/}/*"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your distfiles directory."
}

src_install() {
	local d

	insinto "${DIR}"/Psychonauts2
	doins -r Psychonauts2/Content

	for d in Engine/Binaries/ThirdParty/PhysX3/Linux/x86_64-unknown-linux-gnu \
			 Engine/Plugins/Wwise/ThirdParty/Linux_x64/Release/bin \
			 Psychonauts2/Binaries/Linux
	do
		exeinto "${DIR}/${d}"
		doexe "${d}"/*
	done

	dosym ../..${DIR}/Psychonauts2/Binaries/Linux/Psychonauts2-Linux-Shipping /usr/bin/${MY_PN}

	doicon -s 256 "${DISTDIR}"/${MY_PN}.png
	make_desktop_entry ${MY_PN} "Psychonauts 2" ${MY_PN}
}
