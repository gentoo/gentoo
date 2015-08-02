# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/rescan-scsi-bus/rescan-scsi-bus-1.57-r1.ebuild,v 1.12 2015/08/02 09:58:59 pacho Exp $

EAPI=5

inherit eutils

DESCRIPTION="Script to rescan the SCSI bus without rebooting"
HOMEPAGE="http://www.garloff.de/kurt/linux/"
SCRIPT_NAME="${PN}.sh"
SRC_NAME="${SCRIPT_NAME}-${PV}"
SRC_URI="http://www.garloff.de/kurt/linux/${SRC_NAME}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86" # alpha hppa ppc64 sparc

RDEPEND=">=sys-apps/sg3_utils-1.24
	app-admin/killproc
	virtual/modutils
	app-shells/bash"

S=${WORKDIR}

src_unpack() {
	cp -f "${DISTDIR}"/${SRC_NAME} "${WORKDIR}"/${SCRIPT_NAME}
}

src_install() {
	into /usr
	dosbin ${SCRIPT_NAME}
	# Some scripts look for this without the trailing .sh
	# Some look for it with the trailing .sh, so have a symlink
	dosym ${SCRIPT_NAME} /usr/sbin/${PN}
}
