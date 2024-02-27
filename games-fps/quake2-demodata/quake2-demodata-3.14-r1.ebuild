# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker

#MY_PV=$(delete_all_version_separators)
MY_PV=$(ver_rs 1- '')
MY_PN="quake2"
FILE="q2-${MY_PV}-demo-x86.exe"

DESCRIPTION="Demo data for Quake 2"
HOMEPAGE="https://en.wikipedia.org/wiki/Quake_II"
SRC_URI="mirror://idsoftware/${MY_PN}/${FILE}"
S="${WORKDIR}"

# See license.txt - it's a bit different to Q2EULA in Portage
LICENSE="quake2-demodata"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="symlink"

RDEPEND="!games-fps/quake2-data" # games-fps/quake2-data already includes the demo data
BDEPEND="app-arch/unzip"

dir=usr/share/${MY_PN}

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	insinto ${dir}/demo
	doins -r Install/Data/baseq2/{pak0.pak,players}

	dodoc Install/Data/DOCS/*.txt

	if use symlink ; then
		# Make the demo the default, so that people can just run it,
		# without having to mess with command-line options.
		cd "${ED}"/${dir} || die
		ln -sfn demo baseq2 || die
	fi
}

pkg_postinst() {
	elog "This is just the demo data. To play, install a client"
	elog "such as games-fps/qudos"
	echo

	if use symlink ; then
		elog "baseq2 has been symlinked to demo, for convenience, within:"
		elog "${dir}"
		echo
	fi
}
