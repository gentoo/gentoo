# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator

DESCRIPTION="Printer information files for foomatic-db-engine to generate ppds"
HOMEPAGE="http://www.linuxprinting.org/foomatic.html"
SRC_URI="http://www.openprinting.org/download/foomatic/${PN}-$(replace_version_separator 2 -).tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	net-print/foomatic-db-engine
	!net-print/foo2zjs[hp2600n]"

S="${WORKDIR}/${PN}-$(get_version_component_range 3 ${PV})"

src_prepare() {
	# ppd files do not belong to this package
	rm -r db/source/PPD || die
	default
}

src_configure() {
	econf \
		--disable-gzip-ppds \
		--disable-ppds-to-cups
}

src_install() {
	default
	rmdir "${ED}"/usr/share/foomatic/db/source/PPD || die
	# Avoid collision with foo2zjs, bug 185486
	rm "${ED}"/usr/share/foomatic/db/source/{driver/foo2{hp,lava,xqx,zjs}.xml,printer/{Generic-ZjStream_Printer,HP-{Color_LaserJet_{1500,1600,2600n},LaserJet_{10{00,05,18,20,22},M1005_MFP}},Minolta-{Color_PageWorks_Pro_L,magicolor_2{20,30,43}0_DL},Samsung-CLP-{3,6}00}.xml}  || die
}
