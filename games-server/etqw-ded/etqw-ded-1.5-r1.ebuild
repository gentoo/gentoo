# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="Enemy Territory: Quake Wars dedicated server"
HOMEPAGE="https://www.splashdamage.com/content/et-quake-wars-standalone-server-linux"
SRC_URI="ETQW-server-${PV}-full.x86.run"

LICENSE="ETQW"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="bindist fetch strip"

DEPEND="app-arch/unzip"
RDEPEND="sys-libs/glibc"

S=${WORKDIR}/data
dir=/opt/${PN}

QA_PREBUILT="${dir:1}/pb/*.so
	${dir:1}/*.x86
	${dir:1}/*.so*"

pkg_nofetch() {
	einfo "Please download ${A} from ${HOMEPAGE} and copy it into your DISTDIR directory."
}

src_unpack() {
	tail -c +194885 "${DISTDIR}"/${A} > ${A}.zip || die
	unpack ./${A}.zip
	rm -f ${A}.zip || die
}

src_install() {
	insinto "${dir}"
	doins -r base pb *.txt
	exeinto "${dir}"
	doexe etqwded.x86 *.so*
	make_wrapper ${PN} ./etqwded.x86 "${dir}" "${dir}"
}
