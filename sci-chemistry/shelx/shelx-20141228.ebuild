# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/shelx/shelx-20141228.ebuild,v 1.1 2015/03/05 11:45:35 jlec Exp $

EAPI=5

DESCRIPTION="Programs for crystal structure determination from single-crystal diffraction data"
HOMEPAGE="http://shelx.uni-ac.gwdg.de/SHELX/"
SRC_URI="
	amd64? (
		anode_amd64.bz2
		ciftab_amd64.bz2
		shelxc_amd64.bz2
		shelxd_amd64.bz2
		shelxe_amd64.bz2
		shelxl_amd64.bz2
		shelxs_amd64.bz2
		shelxt_amd64.bz2
		shredcif_amd64.bz2
	)
	x86? (
		anode_x86.bz2
		ciftab_x86.bz2
		shelxc_x86.bz2
		shelxd_x86.bz2
		shelxe_x86.bz2
		shelxl_x86.bz2
		shelxs_x86.bz2
		shelxt_x86.bz2
		shredcif_x86.bz2
	)
"

SLOT="0"
LICENSE="free-noncomm"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

S="${WORKDIR}"

RESTRICT="fetch"

QA_PREBUILT="opt/bin/*"

pkg_nofetch() {
	elog "Go to ${HOMEPAGE}"
	elog "Fill out the application form, and send it in."
	elog "Download ${A} and rename them to"
	use amd64 && elog "*_amd64.bz2"
	use x86 && elog "*_x86.bz2"
	elog "and place renamed tarballs in ${DISTDIR}."
}

src_install() {
	local i
	into /opt
	for i in *; do
		newbin ${i} ${i/_*/}
	done
}
