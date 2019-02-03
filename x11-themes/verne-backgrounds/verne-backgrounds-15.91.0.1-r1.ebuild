# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator rpm

SRC_PATH=development/16/source/SRPMS
FEDORA=16

MY_P="${PN}-$(get_version_component_range 1-3)"

DESCRIPTION="Fedora 16 official background artwork"
HOMEPAGE="https://fedoraproject.org/wiki/F16_Artwork"

SRC_URI="mirror://fedora-dev/${SRC_PATH}/${PN}-$(replace_version_separator 3 -).fc${FEDORA}.src.rpm"

LICENSE="CC-BY-SA-3.0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND=""

S="${WORKDIR}/${MY_P}"

SLOT=0

src_compile() { :; }
src_test() { :; }

src_install() {
	# The install targets are serial anyway.
	emake -j1 DESTDIR="${D}" install

	dodoc Attribution
}
