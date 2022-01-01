# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Script to rescan the SCSI bus without rebooting"
HOMEPAGE="http://www.garloff.de/kurt/linux/"
SCRIPT_NAME="${PN}.sh"
SRC_NAME="${SCRIPT_NAME}-${PV}"
SRC_URI="http://www.garloff.de/kurt/linux/${SRC_NAME}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 s390 sparc x86"

RDEPEND=">=sys-apps/sg3_utils-1.24
	<sys-apps/sg3_utils-1.44
	app-admin/killproc
	app-shells/bash
	sys-apps/kmod[tools]"

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
