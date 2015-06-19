# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/lovelock-backgrounds/lovelock-backgrounds-14.91.1.1.ebuild,v 1.4 2013/02/07 23:01:17 ulm Exp $

EAPI=3

inherit versionator rpm

SRC_PATH=releases/15/Fedora/source/SRPMS
FEDORA=15

MY_P="${PN}-$(get_version_component_range 1-3)"

DESCRIPTION="Fedora official background artwork"
HOMEPAGE="https://fedoraproject.org/wiki/F15_Artwork"

SRC_URI="mirror://fedora-dev/${SRC_PATH}/${PN}-$(replace_version_separator 3 -).fc${FEDORA}.src.rpm"

LICENSE="CC-BY-SA-3.0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="!x11-themes/fedora-backgrounds:15"
DEPEND=""

S="${WORKDIR}/${MY_P}"

SLOT=0

src_unpack() {
	rpm_src_unpack

	# as of 2011-03-08 rpm.eclass does not unpack the further xz
	# file automatically.
	unpack ./${MY_P}.tar.xz
}

src_compile() { :; }
src_test() { :; }

src_install() {
	# The install targets are serial anyway.
	emake -j1 DESTDIR="${D}" install || die "emake install failed"
}
