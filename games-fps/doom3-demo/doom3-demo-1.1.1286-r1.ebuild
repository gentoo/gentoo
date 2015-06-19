# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/doom3-demo/doom3-demo-1.1.1286-r1.ebuild,v 1.3 2015/06/14 19:38:13 ulm Exp $

EAPI=5
inherit eutils unpacker games

DESCRIPTION="Doom III - 3rd installment of the classic id 3D first-person shooter"
HOMEPAGE="http://www.doom3.com/"
SRC_URI="mirror://3dgamers/doom3/doom3-linux-${PV}-demo.x86.run
	mirror://idsoftware/doom3/linux/doom3-linux-${PV}-demo.x86.run
	mirror://gentoo/doom3.png"

LICENSE="DOOM3"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="strip mirror"
QA_EXECSTACK="${GAMES_PREFIX_OPT:1}/${PN}/*"

# Do not remove the amd64 dep unless you are POSITIVE that it is not necessary.
# See bug #88227 for more.
RDEPEND="sys-libs/glibc
	sys-libs/libstdc++-v3:5
	amd64? ( sys-libs/glibc[multilib] sys-libs/libstdc++-v3:5[multilib] )
	>=virtual/opengl-7.0-r1[abi_x86_32(-)]
	>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
	>=x11-libs/libXext-1.3.2[abi_x86_32(-)]"

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/${PN}
Ddir=${D}/${dir}

src_unpack() {
	unpack_makeself doom3-linux-${PV}-demo.x86.run
}

src_install() {
	insinto "${dir}"
	doins License.txt README version.info

	insinto "${dir}"/demo
	doins demo/* || die "doins base"

	exeinto "${dir}"
	doexe gamex86.so bin/Linux/x86/doom.x86

	newicon "${DISTDIR}"/doom3.png ${PN}.png

	games_make_wrapper ${PN} ./doom.x86 "${dir}" "${dir}"
	make_desktop_entry ${PN} "Doom III (Demo)"

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "To play the game run:"
	elog " doom3-demo"
}
