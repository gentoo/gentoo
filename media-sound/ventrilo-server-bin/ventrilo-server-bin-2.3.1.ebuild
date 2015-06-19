# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ventrilo-server-bin/ventrilo-server-bin-2.3.1.ebuild,v 1.5 2014/10/15 15:24:07 pacho Exp $

IUSE=""
DESCRIPTION="The Ventrilo Voice Communication Server"
HOMEPAGE="http://www.ventrilo.com/"
SRC_URI="ventrilo_srv-${PV}-Linux-i386.tar.gz"

LICENSE="ventrilo"
SLOT="0"
KEYWORDS="-* x86 amd64"
RESTRICT="fetch"

S=${WORKDIR}

RDEPEND="sys-libs/glibc"
DEPEND=""

QA_PRESTRIPPED="opt/ventrilo-server/ventrilo_srv
	opt/ventrilo-server/ventrilo_status"

pkg_nofetch() {
	einfo "Please visit http://www.ventrilo.com/download.php"
	einfo "and download the Linux i386 - 32bit ${PV} server."
	einfo "Just save it in ${DISTDIR} !"
}

src_install() {
	exeinto /opt/ventrilo-server
	doexe ventrilo_{srv,status}

	newinitd "${FILESDIR}"/init.d.ventrilo ventrilo
	newconfd "${FILESDIR}"/conf.d.ventrilo ventrilo

	insinto /opt/ventrilo-server
	doins ventrilo_srv.ini

	dohtml ventrilo_srv.htm
}
