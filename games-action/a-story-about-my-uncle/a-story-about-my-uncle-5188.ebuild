# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHECKREQS_DISK_BUILD="1219M"
inherit check-reqs desktop prefix xdg

MY_PN="ASAMU"
MY_P="${MY_PN}_${PV}"
DESCRIPTION="First person platforming adventure about a boy who searches for his lost uncle"
HOMEPAGE="https://www.humblebundle.com/store/a-story-about-my-uncle"
SRC_URI="Linux-NoDRM-${MY_P}.zip
	fetch+https://dev.gentoo.org/~chewi/distfiles/${MY_PN}.png"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist fetch splitdebug"

BDEPEND="
	app-arch/unzip
"

RDEPEND="
	media-libs/libsdl2[opengl,sound,video]
	sys-apps/bubblewrap
	>=sys-devel/gcc-3.4
	>=sys-libs/glibc-2.14
	virtual/opengl
"

S="${WORKDIR}"
DIR="/opt/${MY_PN}"
QA_PREBUILT="${DIR#/}/*"

pkg_nofetch() {
	einfo "Please buy and download Linux-NoDRM-${MY_P}.zip from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your distfiles directory."
}

src_prepare() {
	default
	rm -v Binaries/*/libSDL2-2.0.so.0 || die
}

src_install() {
	insinto "${DIR}"
	doins -r ${MY_PN}/ Engine/

	# The game resets the user config when the timestamps of the other config
	# files change, and doins does not preserve timestamps. Reduce the impact of
	# this by preserving the original timestamps with touch
	local file
	find -type f -name "*.ini" -print0 | while read -rd '' file; do
		touch -r "${file}" "${ED}${DIR}/${file}" || die
	done

	local platform=linux-$(usex amd64 amd64 x86)
	insinto "${DIR}"/Binaries/gentoo
	exeinto "${DIR}"/Binaries/gentoo
	doins Binaries/${platform}/steam_appid.txt
	doexe Binaries/${platform}/{${MY_PN},*.so*}

	keepdir "${DIR}"/${MY_PN}/Saves
	newbin $(prefixify_ro "${FILESDIR}"/wrapper.sh) ${MY_PN}

	doicon -s 64 "${DISTDIR}"/${MY_PN}.png
	make_desktop_entry ${MY_PN} "A Story About My Uncle" ${MY_PN}
}
