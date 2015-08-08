# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

PYTHON_DEPEND=2

inherit eutils python toolchain-funcs

DESCRIPTION="A de novo whole-genome shotgun DNA sequence assembler, also known as the Celera Assembler and CABOG"
HOMEPAGE="http://sourceforge.net/projects/wgs-assembler/"
SRC_URI="mirror://sourceforge/${PN}/wgs-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

DEPEND="
	x11-libs/libXt
	!x11-terms/terminator"
RDEPEND="${DEPEND}
	app-shells/tcsh
	dev-perl/Log-Log4perl"

S="${WORKDIR}/wgs-${PV}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-build.patch
	tc-export CC CXX
}

src_configure() {
	cd "${S}/kmer"
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
	insinto /usr/$(get_libdir)/${PN}
	use static-libs && doins kmer/${MY_S}/lib/*

	insinto /usr/include/${PN}
	doins kmer/${MY_S}/include/*

	insinto /usr/share/${PN}/lib
	doins -r ${MY_S}/bin/TIGR
	rm -rf ${MY_S}/bin/TIGR || die
	dobin ${MY_S}/bin/*
	use static-libs && dolib.a ${MY_S}/lib/*
	dodoc README
}
