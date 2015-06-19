# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/msms-bin/msms-bin-2.6.1-r1.ebuild,v 1.7 2012/05/23 07:56:19 jlec Exp $

EAPI=4

DESCRIPTION="MSMS allows to compute very efficiently triangulations of Solvent Excluded Surfaces"
HOMEPAGE="http://mgl.scripps.edu/people/sanner/html/msms_home.html"
SRC_URI="
			amd64? ( msms_i86_64Linux2_2.6.1.tar.gz )
			x86? ( msms_i86Linux2_2.6.1.tar.gz )
"

LICENSE="MSMS"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RESTRICT="fetch"

S="${WORKDIR}"

QA_PREBUILT="${EROOT#/}opt/bin/.*"

pkg_nofetch() {
	einfo "Please download ${A} from http://mgltools.scripps.edu/downloads#msms and place it to ${DISTDIR}"
}

src_install() {
	doman msms.1
	dodoc README msms.html ReleaseNotes
	exeinto /opt/bin
	if use amd64; then
		newexe ${PN%-bin}.x86_64Linux2.${PV} msms
	elif use x86; then
		newexe ${PN%-bin}.i86Linux2.${PV} msms
	fi
	insinto /usr/share/${PN}/
	doins atmtypenumbers
	sed \
		-e 's:nawk:awk:g' \
		-e "s:./atmtypenumbers:${EPREFIX}/usr/share/${PN}/atmtypenumbers:g" \
		-i pdb_to_xyz* || die
	dobin pdb_to_xyz*
}
