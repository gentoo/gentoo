# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils versionator

# upstream versioning wrong: 3.71 is really 3.7.1
MYP="${PN}-$(delete_version_separator 2)"

DESCRIPTION="Collection of scripts to access the CDS databases"
HOMEPAGE="http://cdsweb.u-strasbg.fr/doc/cdsclient.html"
SRC_URI="ftp://cdsarc.u-strasbg.fr/pub/sw/${MYP}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RESTRICT="mirror bindist"
DEPEND=""
RDEPEND="app-shells/tcsh"

S="${WORKDIR}/${MYP}"

PATCHES=( "${FILESDIR}/${PN}-makefile.patch" )
src_prepare() {
	default
	# remove non standard "mantex" page
	sed -e 's/aclient.tex//' -i configure || die
}

src_install() {
	local bindir="${EPREFIX}/usr/bin/${PN}"
	emake DESTDIR="${D}" SHSDIR="${D}${bindir}" install
	cat <<-EOF > 99${PN}
		PATH=${bindir}
		ROOTPATH=${bindir}
	EOF
	doenvd 99${PN}
}
