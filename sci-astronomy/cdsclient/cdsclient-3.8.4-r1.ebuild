# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# upstream versioning wrong: 3.71 is really 3.7.1
MYP="${PN}-$(ver_rs 2 '')"

DESCRIPTION="Collection of scripts to access the CDS databases"
HOMEPAGE="http://cdsweb.u-strasbg.fr/doc/cdsclient.html"
SRC_URI="ftp://cdsarc.u-strasbg.fr/pub/sw/${MYP}.tar.gz"
S="${WORKDIR}/${MYP}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
RESTRICT="mirror bindist"

RDEPEND="app-shells/tcsh"

PATCHES=( "${FILESDIR}"/${PN}-makefile.patch )

src_install() {
	local bindir="${EPREFIX}/usr/bin/${PN}"
	emake DESTDIR="${D}" SHSDIR="${D}${bindir}" install

	newenvd - 99${PN} <<-EOF
		PATH="${bindir}"
		ROOTPATH="${bindir}"
	EOF
}
