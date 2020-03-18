# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit unpacker eutils versionator games

MY_PV=$(delete_all_version_separators)
MY_PN="quake2"
FILE="q2-${MY_PV}-demo-x86.exe"

DESCRIPTION="Demo data for Quake 2"
HOMEPAGE="https://en.wikipedia.org/wiki/Quake_II"
SRC_URI="mirror://idsoftware/${MY_PN}/${FILE}"

# See license.txt - it's a bit different to Q2EULA in Portage
LICENSE="quake2-demodata"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~x86"
IUSE="symlink"

RDEPEND=""
DEPEND="app-arch/unzip
	!games-fps/quake2-data" # games-fps/quake2-data already includes the demo data

S=${WORKDIR}
dir=${GAMES_DATADIR}/${MY_PN}

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	insinto "${dir}"/demo
	doins -r Install/Data/baseq2/{pak0.pak,players}

	dodoc Install/Data/DOCS/*.txt

	if use symlink ; then
		# Make the demo the default, so that people can just run it,
		# without having to mess with command-line options.
		cd "${D}/${dir}" && ln -sfn demo baseq2
	fi

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "This is just the demo data. To play, install a client"
	elog "such as games-fps/qudos"
	echo

	if use symlink ; then
		elog "baseq2 has been symlinked to demo, for convenience, within:"
		elog "${dir}"
		echo
	fi
}
