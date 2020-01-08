# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit rpm versionator

SRC_PATH=development/15/source/SRPMS
FEDORA=15
MY_P="${PN}-$(get_version_component_range 1-3)"

DESCRIPTION="Fedora 14 official background artwork"
HOMEPAGE="https://fedoraproject.org/wiki/F14_Artwork"
SRC_URI="https://archives.fedoraproject.org/pub/archive/fedora/linux/${SRC_PATH}/${PN}-$(replace_version_separator 3 -).fc${FEDORA}.src.rpm"

LICENSE="CC-BY-SA-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND=""

S="${WORKDIR}/${MY_P}"

src_unpack() {
	rpm_src_unpack

	# as of 2017-07-28 rpm.eclass does not unpack the further lzma
	# file automatically.
	unpack ./${MY_P}.tar.lzma
}

src_compile() { :; }
src_test() { :; }

src_install() {
	# The install targets are serial anyway.
	emake -j1 DESTDIR="${D}" install
}
