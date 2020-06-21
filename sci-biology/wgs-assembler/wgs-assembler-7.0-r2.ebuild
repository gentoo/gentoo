# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="The Celera de novo whole-genome shotgun DNA sequence assembler, aka CABOG"
HOMEPAGE="https://sourceforge.net/projects/wgs-assembler/"
SRC_URI="mirror://sourceforge/${PN}/wgs-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	net-libs/libtirpc
	x11-libs/libXt
	!x11-terms/terminator"
RDEPEND="${DEPEND}
	app-shells/tcsh
	dev-perl/Log-Log4perl"

S="${WORKDIR}/wgs-${PV}"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-libtirpc.patch
)

src_configure() {
	tc-export AR CC CXX

	cd kmer || die
	./configure.sh || die
}

src_compile() {
	# not really an install target
	emake -C kmer -j1 install
	emake -C src -j1 SITE_NAME=LOCAL
}

src_install() {
	OSTYPE=$(uname)
	MACHTYPE=$(uname -m)
	MACHTYPE=${MACHTYPE/x86_64/amd64}
	MY_S="${OSTYPE}-${MACHTYPE}"
	sed -i 's|#!/usr/local/bin/|#!/usr/bin/env |' $(find $MY_S -type f) || die

	sed -i '/sub getBinDirectory ()/ a return "/usr/bin";' ${MY_S}/bin/runCA* || die
	sed -i '/sub getBinDirectoryShellCode ()/ a return "bin=/usr/bin\n";' ${MY_S}/bin/runCA* || die
	sed -i '1 a use lib "/usr/share/'${PN}'/lib";' $(find $MY_S -name '*.p*') || die

	dobin kmer/${MY_S}/bin/*

	insinto /usr/include/${PN}
	doins -r kmer/${MY_S}/include/.

	insinto /usr/share/${PN}/lib
	doins -r ${MY_S}/bin/TIGR
	rm -rf ${MY_S}/bin/TIGR || die
	dobin ${MY_S}/bin/*

	dodoc README
}
