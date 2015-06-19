# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/revenge-of-the-titans/revenge-of-the-titans-1.80.12.ebuild,v 1.5 2015/03/26 20:22:50 mr_bones_ Exp $

EAPI=5
inherit eutils games java-pkg-2

DESCRIPTION="defeat the returning Titan horde in a series of epic ground battles"
HOMEPAGE="http://www.puppygames.net/revenge-of-the-titans/"
SRC_URI="amd64? ( http://downloads.puppygames.net/RevengeOfTheTitans-amd64.tar.gz -> ${P}-amd64.tar.gz )
	x86? ( http://downloads.puppygames.net/RevengeOfTheTitans-i386.tar.gz -> ${P}-i386.tar.gz )"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.6
	virtual/opengl"
DEPEND=""

RESTRICT="mirror bindist strip"

S=${WORKDIR}/${PN//-}

pkg_setup() {
	java-pkg-2_pkg_setup
	games_pkg_setup
}

# nothing to do ... stubs for eclasses
src_configure() { :; }
src_compile() { :; }

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"

	insinto "${dir}"
	doins *.jar

	exeinto "${dir}"
	doexe *.so revenge.sh

	games_make_wrapper ${PN} ./revenge.sh "${dir}" "${dir}"
	doicon revenge.png
	make_desktop_entry ${PN} "Revenge of the Titans" revenge

	prepgamesdirs
}

pkg_preinst() {
	java-pkg-2_pkg_preinst
	games_pkg_preinst
}
