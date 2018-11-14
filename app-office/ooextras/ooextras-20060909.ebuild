# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

DESCRIPTION="OOExtras: Extra Templates for OpenOffice.org!"
HOMEPAGE="http://ooextras.sourceforge.net/"
SRC_URI="mirror://sourceforge/ooextras/${PN}${PV}.tgz"

INSTDIR="/opt/${PN}"
S="${WORKDIR}/downloads"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 -sparc x86"
IUSE=""
RDEPEND="virtual/ooo"
DEPEND="${RDEPEND}"

src_compile() {
	true # nothing to do
}

src_install() {
	dodir ${INSTDIR}
	cp -R -- "${S}"/. "${D}"/${INSTDIR}/
}

pkg_postinst() {
	elog "Please add ${INSTDIR} to your template paths in OpenOffice.org"
	elog "You can do this under:"
	elog "Tools > Options > OpenOffice.org > Paths"
}
