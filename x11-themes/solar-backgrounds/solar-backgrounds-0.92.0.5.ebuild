# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/solar-backgrounds/solar-backgrounds-0.92.0.5.ebuild,v 1.4 2013/02/07 23:04:26 ulm Exp $

EAPI=3

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
	# This old version doesn't have a makefile to perform install.
	insinto /usr/share/backgrounds/solar
	doins -r solar*.xml {normalish,standard,wide}{,.dual} || die

	insinto /usr/share/gnome-background-properties
	doins desktop-*.xml || die
}
