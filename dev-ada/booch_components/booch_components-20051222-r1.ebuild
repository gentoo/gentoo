# Copyright 1999-2015 Gentoo Foundation
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

RDEPEND="virtual/ada
	>=app-eselect/eselect-gnat-0.7"

DEPEND="${RDEPEND}
	app-arch/unzip"

lib_compile() {
	cd ${SL}/GNAT
	make
}

lib_install() {
	# new style booch components install Debug and Release versions, we only
	# need the lib subdir of either
	mkdir -p "${DL}"/Debug
	# both $SL and $DL are under ${WORKDIR}, so no dodir, doins...
	# (as lib_install is  called from src_compile it is not safe to have $DL
	# under $D)
	mv "${SL}"/GNAT/*-Release/lib/* "${DL}"
	mv "${SL}"/GNAT/*-Debug/lib/* "${DL}"/Debug
}

src_install () {
	dodir "${AdalibSpecsDir}/${PN}"
	cd "${S}"
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

pkg_postinst(){
	einfo "Updating gnat configuration to pick up ${PN} library..."
	eselect gnat update
	elog "The environment has been set up to make gnat automatically find files in"
	elog "Booch components. In order to immediately activate these settings please do"
	elog "env-update"
	elog "source /etc/profile"
	elog "Otherwise the settings will become active next time you login"
}
