# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Adaptec RAID Controller Command Line Utility"
HOMEPAGE="http://www.adaptec.com/en-us/downloads/"
SRC_URI="http://download.adaptec.com/raid/storage_manager/${PN}_v${PV//./_}.zip"

LICENSE="Adaptec-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

RESTRICT="mirror bindist"
# RESTRICT="fetch"

QA_PRESTRIPPED="/opt/bin/arcconf"

S="${WORKDIR}"

# Maintainer notes:
# * When going via the $HOMEPAGE one has to agree to the Adaptec-EULA as
#   referenced above.
# * Despite that EULA, one can download the package seemingly without
#   restrictions from $SRC_URI.
# * It is therefore assumed that the binary is made available for public
#   download. Even more so since the archive does not contain a license
#   agreement stating otherwise.

#pkg_nofetch() {
#	einfo "Upstream has implemented a mandatory clickthrough EULA for distfile download"
#	einfo "Please visit $HOMEPAGE, choose a controller (for example the Series 7, 7805)"
#	einfo "and then navigate to Storage Manager Downloads for the ARCCONF Command Line Utility."
#	einfo "And place $A in ${DISTDIR}"
#}

# Maintainer notes:
# * FreeBSD binaries would be available for FreeBSD 7..9, which ones do we need?
src_install() {
	exeinto /opt/bin

	if use amd64 ; then
		doexe linux_x64/arcconf
	else
		doexe linux_x86/arcconf
	fi
}
