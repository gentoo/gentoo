# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit gnatbuild

DESCRIPTION="GNAT Ada Compiler - AdaCore GPL version"
HOMEPAGE="https://libre2.adacore.com/"
LICENSE="GPL-2"

SRC_URI="ftp://gcc.gnu.org/pub/gcc/releases/gcc-${GCCVER}/gcc-core-${GCCVER}.tar.bz2
	http://www.adaic.org/standards/05rm/RM-05-Html.zip
	mirror://gentoo/${PN}-3.4.5.1-src.tar.bz2
	mirror://gentoo/${PN}-gcc-${SLOT}.diff.bz2
	x86?   ( mirror://gentoo/gnatboot-${BOOT_SLOT}-i386.tar.bz2 )
	amd64? ( mirror://gentoo/gnatboot-${BOOT_SLOT}-amd64-r2.tar.bz2 )"
# ${BOOT_SLOT} and ${GCCVER} are defined in gnatbuild.eclass and depend
# only on $PV, so should be safe to use in DEPEND/SRC_URI

KEYWORDS="~amd64 ~x86"
DEPEND="app-arch/unzip"
RDEPEND=""

IUSE=""

GNATSOURCE="${WORKDIR}/${P}-src"

src_unpack() {
	gnatbuild_src_unpack base_unpack

	# prep gcc sources for Ada
	mv "${GNATSOURCE}/src/ada" "${S}/gcc"
	cd "${S}"
	epatch "${WORKDIR}"/${PN}-gcc-${SLOT}.diff

	gnatbuild_src_unpack common_prep

	# one of the converted gcc->gnatgcc in common_prep needs to stay gcc in
	# fact in this version
	sed -i -e 's:(Last3 = "gnatgcc"):(Last3 = "gcc"):' "${S}/gcc/ada/makegpr.adb"
}

src_install() {
	gnatbuild_src_install install

	# there is something strange with provided Makefiles, causing an
	# access violation on gprmake. Have to do funny things..
	make DESTDIR="${D}" bindir="${D}${BINPATH}"  install || die
	mv "${D}${D}${PREFIX}/${CTARGET}" "${D}${PREFIX}"
	rm -rf "${D}var"

	gnatbuild_src_install move_libs cleanup prep_env

	# docs have to be fetched from 3rd place, quite messy package
	dodir /usr/share/doc/${PF}/html
	dohtml "${WORKDIR}"/*.html

	# misc notes and examples
	cd ${GNATSOURCE}
	dodoc README features-503 features-ada0y known-problems-503a
	cp -pPR examples/ "${D}/usr/share/doc/${PF}/"

	# this version of gnat does not provide info files yet
	rm -f "${D}"${DATAPATH}/info/gnat.info
}

pkg_postinst() {
	gnatbuild_pkg_postinst

	elog
	elog "This is an experimental issue of the gnat-gpl compiler, supporting"
	elog "some of the new features of Ada2005. You may consider registering with"
	elog "AdaCore at https://libre2.adacore.com/."
	elog
	ewarn "Please note!!!"
	ewarn "gnat-gpl is distributed under the GPL-2 license, without the GMGPL provision!!"
	ewarn "For the GMGPL version you may look at the gnat-gcc compiler."
	ewarn
}
