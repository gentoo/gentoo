# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Printer information files for foomatic-db-engine to generate ppds"
HOMEPAGE="https://openprinting.github.io/"
# Upstream removes the tarball every day: store a copy in our devspace for
# people not relying on our mirrors
SRC_URI="http://www.openprinting.org/download/foomatic/${PN}-$(ver_rs 2 -).tar.xz
	https://dev.gentoo.org/~pacho/${PN}/${PN}-$(ver_rs 2 -).tar.xz"
S=${WORKDIR}/${PN}-$(ver_cut 3)

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

RDEPEND="net-print/foomatic-db-engine"

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

	cd "${ED}"/usr/share/foomatic/db/source/ || die
	rm -r PPD || die
	# Avoid collision with foo2zjs, bug 185486
	local FILES=(
		driver/foo2{hp,lava,xqx,zjs}.xml
		printer/Generic-ZjStream_Printer.xml
		printer/HP-Color_LaserJet_{1500,1600,2600n}.xml
		printer/HP-LaserJet_10{00,05,18,20,22}.xml printer/HP-LaserJet_M1005_MFP.xml
		printer/Minolta-Color_PageWorks_Pro_L.xml printer/Minolta-magicolor_2{20,30,43}0_DL.xml
		printer/Samsung-CLP-{3,6}00.xml
	)
	rm -v "${FILES[@]}" || die
}
