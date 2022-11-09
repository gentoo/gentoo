# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm

MY_PV="${PV//./-}"
MY_P=${MY_PV}_MegaCLI

DESCRIPTION="LSI Logic MegaRAID Command Line Interface management tool"
HOMEPAGE="https://www.broadcom.com/support/knowledgebase/1211161498596/megacli-cheat-sheet--live-examples https://www.broadcom.com/support/knowledgebase/1211161496959/megacli-commands"
# This file is '[zip]	MegaCLI 5.5 P2', Date: 01/20/2014   Size: 7753 KB
SRC_URI="https://docs.broadcom.com/docs-and-downloads/raid-controllers/raid-controllers-common-files/${MY_P}.zip"
S="${WORKDIR}"

LICENSE="LSI"
SLOT="0"
# This package can never enter stable, it can't be mirrored and upstream
# can remove the distfiles from their mirror anytime.
KEYWORDS="amd64 x86"
# Previous releases from LSI directly required a click-through EULA; but the
# upstream website no longer requires this consistently: most old files have
# two or more download pages, and while one of the pages has a generic
# click-through download form, the file-specific download page only requires
# click-through on some items. See also sys-block/lsiutil
RESTRICT="mirror bindist"

BDEPEND="
	app-admin/chrpath
	app-arch/unzip"
# links to glibc and libstdc++/libgcc_s
RDEPEND="
	sys-devel/gcc
	sys-libs/glibc
	sys-libs/ncurses-compat:5"

QA_PREBUILT="
	/opt/${PN}/${PN}
	/opt/${PN}/lib/*"

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	rpm_unpack ./Linux/MegaCli-${PV}-1.noarch.rpm
}

src_install() {
	newdoc "${PV}_MegaCLI.txt" RELEASE.txt

	exeinto /opt/megacli
	libsysfs=libstorelibir-2.so.14.07-0
	case ${ARCH} in
		amd64) MegaCli=MegaCli64;;
		x86) MegaCli=MegaCli;;
		*) die "invalid ARCH";;
	esac
	newexe opt/MegaRAID/MegaCli/${MegaCli} ${PN}

	exeinto /opt/${PN}/lib
	doexe opt/MegaRAID/MegaCli/${libsysfs}

	into /opt
	newbin "${FILESDIR}"/${PN}-wrapper ${PN}
	dosym ${PN} /opt/bin/MegaCli

	# Remove DT_RPATH
	chrpath -d "${ED}"/opt/${PN}/${PN} || die
}

pkg_postinst() {
	einfo
	einfo "See /usr/share/doc/${PF}/RELEASE.txt for a list of supported controllers"
	einfo "(contains LSI model names only, not those sold by 3rd parties"
	einfo "under custom names like Dell PERC etc)."
	einfo
	einfo "As there's no dedicated manual, you might want to have"
	einfo "a look at the following cheat sheet (originally written"
	einfo "for Dell PowerEdge Expandable RAID Controllers):"
	einfo "http://tools.rapidsoft.de/perc/perc-cheat-sheet.html"
	einfo
	einfo "For more information about working with Dell PERCs see:"
	einfo "http://tools.rapidsoft.de/perc/"
	einfo
}
