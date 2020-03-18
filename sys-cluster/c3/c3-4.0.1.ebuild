# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
	for TOOL in $(find . -maxdepth 1 -type f -name 'c*' -not -name '*.*'); do
		doexe ${TOOL}
	done
	# Get systemimager-using tool out of bin, since systemimager isn't in
	# portage
	dodoc ${D}/${C3DIR}/cpushimage
	rm ${D}/${C3DIR}/cpushimage || die

	dodoc README README.scale CHANGELOG KNOWN_BUGS
	docinto contrib
	dodoc contrib/*

	doman man/man*/*

	newenvd - 40${PN} <<-EOF
		PATH=${C3DIR}
		ROOTPATH=${C3DIR}
	EOF
}

pkg_postinst() {
	einfo "Because systemimager is not in Portage, cpushimage"
	einfo "has been installed to /usr/share/doc/${P}/."
}
