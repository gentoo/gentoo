# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit eutils

MY_P="powerpc-utils-papr-${PV}"

DESCRIPTION="Utilities for the maintenance of IBM PowerPC platforms"
SRC_URI="http://powerpc-utils.ozlabs.org/releases/powerpc-utils-papr-${PV}.tar.gz"
HOMEPAGE="http://powerpc-utils.ozlabs.org/"

S="${WORKDIR}/${MY_P}"

SLOT="0"
LICENSE="IBM"
KEYWORDS="~ppc ~ppc64"
IUSE=""
RDEPEND=">=sys-apps/ibm-powerpc-utils-1.1.2
	sys-libs/librtas
	virtual/logger"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/ibm-powerpc-utils-papr-${PV}-removeinitandvscsis.patch
}

src_install() {
	make DESTDIR="${D}" install || die "Compilation failed"
}

pkg_postinst() {
	einfo "Support for the IBM Virtual SCSI server (virtual disk) "
	einfo "is not included in this version of powerpc-utils-papr. "
	einfo "When the ibmvscsis function is generally available in  "
	einfo "the kernel source trees, it will be added back in."
}
