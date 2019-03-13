# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rpm versionator

SRC_PATH=releases/15/Fedora/source/SRPMS
FEDORA=15
MY_P="${PN}-$(get_version_component_range 1-3)"

DESCRIPTION="Fedora 15 official background artwork"
HOMEPAGE="https://fedoraproject.org/wiki/F15_Artwork"
SRC_URI="mirror://fedora-dev/${SRC_PATH}/${PN}-$(replace_version_separator 3 -).fc${FEDORA}.src.rpm"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND=""

S="${WORKDIR}/${MY_P}"

src_compile() { :; }
src_test() { :; }

src_install() {
	# The install targets are serial anyway.
	emake -j1 DESTDIR="${D}" install
}
