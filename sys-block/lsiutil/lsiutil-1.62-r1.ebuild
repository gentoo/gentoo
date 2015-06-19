# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/lsiutil/lsiutil-1.62-r1.ebuild,v 1.1 2013/06/10 12:18:31 dev-zero Exp $

EAPI="5"

DESCRIPTION="LSI Logic Fusion MPT Command Line Interface management tool"
HOMEPAGE="http://www.lsi.com/"
SRC_URI="http://www.lsi.com/downloads/Public/Obsolete/Obsolete%20Common%20Files/LSIUtil_${PV}.zip"

LICENSE="LSI"
SLOT="0"
# This package can never enter stable, it can't be mirrored and upstream
# can remove the distfiles from their mirror anytime.
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE=""

RESTRICT="fetch mirror bindist"

RDEPEND=""
DEPEND="app-arch/unzip"

QA_PRESTRIPPED="/opt/bin/lsiutil"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Upstream has implemented a mandatory clickthrough EULA for distfile download"
	einfo "Please visit $SRC_URI"
	einfo "And place $A in ${DISTDIR}"
}

src_install() {
	exeinto /opt/bin

	if use x86; then
		doexe Linux/lsiutil || die
	elif use amd64; then
		newexe Linux/lsiutil.x86_64 lsiutil
	elif use ia64; then
		newexe Linux/lsiutil.ia64 lsiutil
	fi

	dodoc changes.txt
}
