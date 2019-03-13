# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit rpm
MY_P=${PV}_MegaCLI_Linux

DESCRIPTION="LSI Logic MegaRAID Command Line Interface management tool"
HOMEPAGE="http://www.lsi.com/"
SRC_URI="http://www.lsi.com/downloads/Public/RAID%20Controllers/RAID%20Controllers%20Common%20Files/${MY_P}.zip"

LICENSE="LSI"
SLOT="0"
# This package can never enter stable, it can't be mirrored and upstream
# can remove the distfiles from their mirror anytime.
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/unzip
	app-admin/chrpath"
RDEPEND="sys-libs/ncurses:5"

S=${WORKDIR}/${MY_P}

RESTRICT="mirror fetch"
QA_PREBUILT="/opt/${PN}/${PN}
	/opt/${PN}/lib/*"

pkg_nofetch() {
	einfo "Upstream has implement a mandatory clickthrough EULA for distfile download"
	einfo "Please visit $SRC_URI"
	einfo "And place $A into your DISTDIR directory"
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	rpm_unpack ./"Linux MegaCLI ${PV}"/MegaCli-${PV}-1.noarch.rpm
}

src_install() {
	newdoc "Linux MegaCLI ${PV}.txt" RELEASE.txt

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
	chrpath -d "${D}"/opt/${PN}/${PN}
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
