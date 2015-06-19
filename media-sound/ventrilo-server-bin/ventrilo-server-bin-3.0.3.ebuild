# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ventrilo-server-bin/ventrilo-server-bin-3.0.3.ebuild,v 1.6 2014/10/15 15:24:07 pacho Exp $

inherit eutils user

IUSE=""
DESCRIPTION="The Ventrilo Voice Communication Server"
HOMEPAGE="http://www.ventrilo.com/"
SRC_URI="ventrilo_srv-${PV}-Linux-i386.tar.gz"

LICENSE="ventrilo"
SLOT="0"
KEYWORDS="-* amd64 x86"
RESTRICT="fetch"

S=${WORKDIR}

RDEPEND="sys-libs/glibc"
DEPEND=""

QA_PRESTRIPPED="opt/ventrilo-server/ventrilo_srv
	opt/ventrilo-server/ventrilo_status"

pkg_setup() {
	enewgroup ventrilo 3784
	enewuser ventrilo 3784 -1 /dev/null ventrilo
}

pkg_nofetch() {
	elog "Please visit http://www.ventrilo.com/download.php"
	elog "and download the Linux i386 - 32bit ${PV} server."
	elog "Just save it in ${DISTDIR} !"
}

src_install() {
	cd "${S}/ventsrv"

	exeinto /opt/ventrilo-server
	doexe ventrilo_{srv,status}

	newinitd "${FILESDIR}"/${PV}-init.d.ventrilo ventrilo
	newconfd "${FILESDIR}"/${PV}-conf.d.ventrilo ventrilo

	insinto /opt/ventrilo-server
	doins ventrilo_srv.ini

	dohtml ventrilo_srv.htm

	fowners ventrilo:ventrilo /opt/ventrilo-server
}
