# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="MSMS very efficiently computes triangulations of Solvent Excluded Surfaces"
HOMEPAGE="http://mgl.scripps.edu/people/sanner/html/msms_home.html"
SRC_URI="
	amd64? ( msms_i86_64Linux2_2.6.1.tar.gz )
	x86? ( msms_i86Linux2_2.6.1.tar.gz )"

LICENSE="MSMS"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
RESTRICT="fetch"

S="${WORKDIR}"

QA_PREBUILT="opt/bin/*"

pkg_nofetch() {
	einfo "Please download ${A} from http://mgltools.scripps.edu/downloads#msms and"
	einfo "place it into your DISTDIR directory."
}

src_install() {
	dobin pdb_to_xyz*

	exeinto /opt/bin
	newexe ${PN%-bin}.$(usex amd64 x86_64Linux2 i86Linux2).${PV} msms

	dodoc README msms.html ReleaseNotes
	doman msms.1

	insinto /usr/share/${PN}/
	doins atmtypenumbers
	sed \
		-e 's:nawk:awk:g' \
		-e "s:./atmtypenumbers:${EPREFIX}/usr/share/${PN}/atmtypenumbers:g" \
		-i pdb_to_xyz* || die
}
