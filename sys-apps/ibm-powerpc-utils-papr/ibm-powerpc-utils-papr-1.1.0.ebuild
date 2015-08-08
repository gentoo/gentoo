# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

MY_P="powerpc-utils-papr-${PV}"

DESCRIPTION="This package provides the utilities which are intended for the maintenance of IBM powerpc platforms"
SRC_URI="http://powerpc-utils.ozlabs.org/releases/powerpc-utils-papr-${PV}.tar.gz"
HOMEPAGE="http://powerpc-utils.ozlabs.org/"

S="${WORKDIR}/${MY_P}"

SLOT="0"
LICENSE="IBM"
KEYWORDS="ppc ppc64"
IUSE=""
RDEPEND=">=sys-apps/ibm-powerpc-utils-1.1.0
	sys-libs/librtas
	virtual/logger"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/ibm-powerpc-utils-papr-1.1.0-remove-doc.patch
	epatch "${FILESDIR}"/ibm-powerpc-utils-papr-1.1.0-removeinitandvscsis.patch
}

src_install() {
	make DESTDIR="${D}" install || die "Compilation failed"
	dodoc README COPYRIGHT
	#dodir /etc/init.d
	#exeinto /etc/init.d
	#newexe ${FILESDIR}/ibmvscsis ibmvscsis
}

pkg_postinst() {
	#einfo "An initscript for managing virtual scsi servers has "
	#einfo "been install into /etc/init.d/ called ibmviscsis. "
	#einfo "Before you can use this daemon, you must create a proper "
	#einfo "/etc/ibmvscsis.conf file."
	einfo "Support for the IBM Virtual SCSI server (virtual disk) "
	einfo "is not included in this version of powerpc-utils-papr. "
	einfo "When the ibmvscsis function is generally available in  "
	einfo "the kernel source trees, it will be added back in."
}
