# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit games

DESCRIPTION="Enemy Territory: Quake Wars dedicated server"
HOMEPAGE="http://www.splashdamage.com/content/et-quake-wars-standalone-server-linux"
SRC_URI="ETQW-server-${PV}-full.x86.run"

LICENSE="ETQW"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="fetch strip"

DEPEND="app-arch/unzip"
RDEPEND="sys-libs/glibc"

S=${WORKDIR}/data
dir=${GAMES_PREFIX_OPT}/${PN}

QA_TEXTRELS="${dir:1}/pb/*.so"
QA_EXECSTACK="${dir:1}/*.x86
	${dir:1}/*.so*"

pkg_nofetch() {
	einfo "Please download ${A} from ${HOMEPAGE} and copy it to ${DISTDIR}"
}

src_unpack() {
	tail -c +194885 "${DISTDIR}"/${A} > ${A}.zip
	unpack ./${A}.zip
	rm -f ${A}.zip
}

src_install() {
	insinto "${dir}"
	doins -r base pb *.txt
	exeinto "${dir}"
	doexe etqwded.x86 *.so*
	games_make_wrapper ${PN} ./etqwded.x86 "${dir}" "${dir}"
	prepgamesdirs
}
