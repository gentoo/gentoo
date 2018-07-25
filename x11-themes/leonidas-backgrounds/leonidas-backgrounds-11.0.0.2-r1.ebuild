# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator rpm

SRC_PATH=development/15/source/SRPMS
FEDORA=12

MY_P="${PN}-$(get_version_component_range 1-3)"

DESCRIPTION="Fedora 11 official background artwork"
HOMEPAGE="https://fedoraproject.org/wiki/F11_Artwork"

SRC_URI="mirror://fedora-dev/${SRC_PATH}/${PN}-$(replace_version_separator 3 -).fc${FEDORA}.src.rpm"

LICENSE="CC-BY-SA-2.0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="!x11-themes/fedora-backgrounds:11"
DEPEND=""

S="${WORKDIR}/${MY_P}"

SLOT="0"

src_unpack() {
	rpm_src_unpack
	unpack ./${MY_P}.tar.lzma
}

src_compile() { :; }
src_test() { :; }

src_install() {
	dodoc Credits

	insinto /usr/share/backgrounds/leonidas
	doins -r leonidas* landscape lion

	insinto /usr/share/gnome-background-properties
	doins desktop-*.xml
}
