# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit obs-service

HASH="git.1375261502.72b5224"
SRC_URI="${OBS_URI}/${P}+${HASH}.tar.gz"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}
	dev-vcs/git
"

S="${WORKDIR}/${P}+${HASH}"

src_unpack() {
	default
}

src_install() {
	# different folder and files in this module
	exeinto /usr/libexec/obs/service
	doexe ${OBS_SERVICE_NAME}

	insinto /usr/libexec/obs/service
	doins ${OBS_SERVICE_NAME}.service
}
