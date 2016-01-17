# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="LSI Logic Fusion MPT Command Line Interface management tool"
HOMEPAGE="http://www.avagotech.com/"
SRC_URI="http://docs.avagotech.com/docs-and-downloads/legacy-host-bus-adapters/legacy-host-bus-adapters-common-files/LSIUtil_${PV/./-}.zip"

LICENSE="LSI"
SLOT="0"
# This package can never enter stable, it can't be mirrored and upstream
# can remove the distfiles from their mirror anytime.
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE=""

RESTRICT="mirror bindist"

RDEPEND=""
DEPEND="app-arch/unzip"

QA_PRESTRIPPED="/opt/bin/lsiutil"

S="${WORKDIR}"

src_install() {
	exeinto /opt/bin

	if use x86; then
		doexe Linux/lsiutil || die
	elif use amd64; then
		newexe Linux/lsiutil.x86_64 lsiutil || die
	elif use ia64; then
		newexe Linux/lsiutil.ia64 lsiutil || die
	fi

	dodoc changes.txt
}
