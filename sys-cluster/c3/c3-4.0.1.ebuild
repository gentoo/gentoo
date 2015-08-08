# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="The Cluster Command and Control (C3) tool suite"
HOMEPAGE="http://www.csm.ornl.gov/torc/C3/"
SRC_URI="http://www.csm.ornl.gov/torc/C3/Software/${PV}/${P}.tar.gz"
LICENSE="C3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
# Everything it needs is in "system" (profiles/base/packages)
DEPEND=""

src_compile() {
	:
}

src_install() {
	# The Install-c3 script is a complete hack, so we do this ourselves.
	# CHANGELOG says it's FHS-compliant to put stuff here, so we'll believe it.
	local C3DIR="/opt/c3-4"
	dodir ${C3DIR}

	# "libraries"
	insinto ${C3DIR}
	doins *.py

	# tools
	exeinto ${C3DIR}
	# Everything's in the same dir, so we need to weed out non-tool things
	local TOOL
	for TOOL in $(find ${S} -maxdepth 1 -type f -name 'c*' -not -name '*.*'); do
		doexe ${TOOL}
	done
	# Get systemimager-using tool out of bin, since systemimager isn't in
	# portage
	dodoc ${D}/${C3DIR}/cpushimage
	rm ${D}/${C3DIR}/cpushimage

	dodoc README README.scale CHANGELOG KNOWN_BUGS
	docinto contrib
	dodoc contrib/*

	doman man/man*/*

	# Create env.d file
	echo "PATH=${C3DIR}" > ${T}/40${PN}
	echo "ROOTPATH=${C3DIR}" >> ${T}/40${PN}
	doenvd ${T}/40${PN}
}

pkg_postinst() {
	einfo "Because systemimager is not in Portage, cpushimage"
	einfo "has been installed to /usr/share/doc/${P}/."
}
