# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/obs-service-tar_scm/obs-service-tar_scm-0.3.1.ebuild,v 1.1 2013/11/02 09:35:47 scarabeus Exp $

EAPI=5

inherit obs-service

HASH="1383144507.58d1af8"
SRC_URI="${OBS_URI}/${P}.${HASH}.tar.gz"
IUSE=""
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND="${DEPEND}
	dev-vcs/bzr
	dev-vcs/git
	dev-vcs/mercurial
	dev-vcs/subversion
"

S="${WORKDIR}/${P}.${HASH}"

src_unpack() {
	default
}

src_install() {
	# different folder and files in this module
	exeinto /usr/libexec/obs/service
	doexe ${OBS_SERVICE_NAME}

	insinto /usr/libexec/obs/service
	doins ${OBS_SERVICE_NAME}.service

	insinto /etc/obs/services
	newins ${OBS_SERVICE_NAME}.rc ${OBS_SERVICE_NAME}
}
