# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="LSI Logic Fusion MPT Command Line Interface management tool"
HOMEPAGE="https://www.broadcom.com/"
SRC_URI="https://docs.broadcom.com/docs-and-downloads/legacy-host-bus-adapters/legacy-host-bus-adapters-common-files/LSIUtil_${PV/./-}.zip"

# This package can never enter stable, it can't be mirrored and upstream
# can remove the distfiles from their mirror anytime.
LICENSE="LSI"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
RESTRICT="mirror bindist"

BDEPEND="app-arch/unzip"

QA_PREBUILT="*"

S="${WORKDIR}"

src_install() {
	exeinto /opt/bin
	use amd64 && newexe Linux/lsiutil.x86_64 lsiutil
	use ia64 && newexe Linux/lsiutil.ia64 lsiutil
	use x86 && doexe Linux/lsiutil

	dodoc changes.txt
}
