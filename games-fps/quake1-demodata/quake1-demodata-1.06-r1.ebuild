# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=$(ver_rs 1- '')
MY_PN="quake"

DESCRIPTION="Demo data for Quake 1"
HOMEPAGE="https://en.wikipedia.org/wiki/Quake_I"
SRC_URI="mirror://idsoftware/${MY_PN}/${MY_PN}${MY_PV}.zip"
S="${WORKDIR}"

# See licinfo.txt
LICENSE="quake1-demodata"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="symlink"

RDEPEND="symlink? ( !games-fps/quake1-data )"
BDEPEND="
	app-arch/lha
	app-arch/unzip
"

dir=usr/share/${MY_PN}1

pkg_setup() {
	if has_version "games-fps/quake1-data" ; then
		ewarn "games-fps/quake1-data already includes the demo data,"
		ewarn "so this installation is not very useful."
	fi
}

src_unpack() {
	unpack ${A}

	# File rename for bug #159100
	mv resource.{1,x} || die

	lha xfq resource.x || die "lha failed"
	# Don't want to conflict with the cdinstall files
	mv ID1 demo || die
}

src_install() {
	insinto ${dir}
	doins -r demo

	dodoc *.TXT

	if use symlink ; then
		# Make the demo the default, so that people can just run it,
		# without having to mess with command-line options.
		cd "${ED}/${dir}" || die
		ln -sfn demo id1 || die
	fi
}

pkg_postinst() {
	elog "This is just the demo data."
	elog "You will still need a Quake 1 client, to play, such as darkplaces."
	echo

	if use symlink ; then
		elog "id1 has been symlinked to demo, for convenience, within:"
		elog "${dir}"
		echo
	fi
}
