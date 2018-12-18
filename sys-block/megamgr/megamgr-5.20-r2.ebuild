# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="LSI Logic MegaRAID Text User Interface management tool"
HOMEPAGE="http://www.lsi.com"
SRC_URI="http://www.lsi.com/downloads/Public/MegaRAID%20Common%20Files/ut_linux_${PN##mega}_${PV}.zip"

LICENSE="LSI"
SLOT="0"
# This package can never enter stable, it can't be mirrored and upstream
# can remove the distfiles from their mirror anytime.
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror fetch"

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"

QA_PRESTRIPPED="/opt/bin/megamgr"

pkg_nofetch() {
	einfo "Upstream has implement a mandatory clickthrough EULA for distfile download"
	einfo "Please visit ${SRC_URI}"
	einfo "And place ${A} in your DISTDIR directory"
}

src_install() {
	exeinto /opt/bin
	newexe megamgr.bin megamgr

	newdoc ut_linux_${PN##mega}_${PV}.txt ${PN}-release-${PV}.txt
}
