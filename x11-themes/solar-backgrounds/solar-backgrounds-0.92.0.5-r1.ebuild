# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator rpm

SRC_PATH=development/15/source/SRPMS
FEDORA=15

MY_P="${PN}-$(get_version_component_range 1-3)"

DESCRIPTION="Fedora official background artwork"
HOMEPAGE="https://fedoraproject.org/wiki/F11_Artwork"

SRC_URI="mirror://fedora-dev/${SRC_PATH}/${PN}-$(replace_version_separator 3 -).fc${FEDORA}.src.rpm"

LICENSE="CC-BY-SA-2.0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND=""

S="${WORKDIR}/${MY_P/-backgrounds/}"

SLOT="0"

src_compile() { :; }
src_test() { :; }

src_install() {
	insinto /usr/share/backgrounds/solar
	doins -r solar*.xml {normalish,standard,wide}{,.dual}

	insinto /usr/share/gnome-background-properties
	doins desktop-*.xml
}
