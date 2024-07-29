# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker wrapper

DIST_PV=$(ver_cut 2-)

DESCRIPTION="An epic action experience combining modern technology with addictive playability"
HOMEPAGE="http://shadowgroundsgame.com/"
# FIXME: PV should perhaps be 0_p1, in which case a filter is in order
SRC_URI="shadowgroundsUpdate${DIST_PV/p/}.run"
S="${WORKDIR}"

LICENSE="frozenbyte-eula"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="fetch strip"

RDEPEND="
	>=sys-devel/gcc-4.3.0
	>=sys-libs/glibc-2.4
	!amd64? (
		gnome-base/libglade
		sys-libs/zlib
	)
	amd64? (
		>=gnome-base/libglade-2.6.4-r1[abi_x86_32(-)]
		sys-libs/zlib[abi_x86_32(-)]
	)
"
BDEPEND="app-arch/unzip"

d="opt/${PN}"
QA_TEXTRELS_x86="`echo ${d#/}/lib32/lib{avcodec.so.51,avformat.so.52,avutil.so.49,FLAC.so.8}`"
QA_TEXTRELS_amd64=${QA_TEXTRELS_x86}

pkg_nofetch() {
	einfo "Fetch ${SRC_URI} and put it into your DISTDIR directory."
	einfo "See http://www.humblebundle.com/ for more info."
}

src_unpack() {
	# Manually run unzip as the initial seek causes it to exit(1)
	unpack_zip ${A}
	rm lib*/lib{gcc_s,m,rt,selinux,z}.so.? || die
}

src_install() {
	local b bb

	doicon Shadowgrounds.xpm
	for b in bin launcher ; do
		bb="shadowgrounds-${b}"
		exeinto ${d}
		newexe ${bb} ${bb}

		make_wrapper ${bb} "./${bb}" "${d}"
		make_desktop_entry ${bb} "Shadowgrounds ${b}" Shadowgrounds
	done

	exeinto ${d}/lib32
	doexe lib32/*

	insinto ${d}
	doins -r Config data Profiles *.fbz *.glade *-logo.png
}
