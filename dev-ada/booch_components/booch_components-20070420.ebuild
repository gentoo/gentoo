# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

IUSE="doc"

inherit gnat

My_PN="bc"
S="${WORKDIR}/${My_PN}-${PV}"
DESCRIPTION="Booch Components for Ada"
SRC_URI="mirror://sourceforge/booch95/${My_PN}-${PV}.tgz
	mirror://sourceforge/booch95/${My_PN}-html-${PV}.zip"

HOMEPAGE="http://booch95.sourceforge.net/"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
SLOT="0"

RDEPEND="virtual/ada"

DEPEND="${RDEPEND}
	app-arch/unzip"

lib_compile() {
	cd "${SL}"/GNAT
	make
}

lib_install() {
	mkdir -p "${DL}"/Debug
	mv "${SL}"/GNAT/*-Release/lib/* "${DL}"
	mv "${SL}"/GNAT/*-Debug/lib/* "${DL}"/Debug
	chmod 0444 "${DL}"/*.ali "${DL}"/Debug/*.ali
}

src_install () {
	dodir "${AdalibSpecsDir}/${PN}"
	insinto "${AdalibSpecsDir}/${PN}"
	doins *.ad?

	#set up environment
	echo "LDPATH=%DL%" > ${LibEnv}
	echo "ADA_OBJECTS_PATH=%DL%" >> ${LibEnv}
	echo "ADA_INCLUDE_PATH=${AdalibSpecsDir}/${PN}" >> ${LibEnv}

	gnat_src_install

	# Install documentation.
	dodoc README
	if use doc ; then
		einfo "installing docs"
		cd "${WORKDIR}"
		dohtml *.html *.gif *.jpg
		cp coldframe-hash.* x.ada "${D}"/usr/share/doc/${PF}/html

		cd "${S}"
		dodir /usr/share/doc/${PF}/demo
		insinto /usr/share/doc/${PF}/demo
		doins demo/*

		dodir /usr/share/doc/${PF}/test
		insinto /usr/share/doc/${PF}/test
		doins test/*
	fi
}
