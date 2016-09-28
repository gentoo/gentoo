# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vdr-plugin-2

VERSION="1060" # every bump, new version!

DESCRIPTION="VDR Plugin: Recover deleted recordings of VDR"
HOMEPAGE="http://projects.vdr-developer.org/projects/plg-undelete"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~arm x86"
IUSE=""

DEPEND=">=media-video/vdr-1.5.7"
RDEPEND="${DEPEND}"

src_prepare() {
	vdr-plugin-2_src_prepare

	if has_version ">=media-video/vdr-2.1.2"; then
		sed -e "s#VideoDirectory#cVideoDirectory::Name\(\)#" \
			-i menuundelete.c

		sed -e "s#RemoveVideoFile#cVideoDirectory::RemoveVideoFile#" \
			-i undelete.c menuundelete.c

		sed -e "s#RenameVideoFile#cVideoDirectory::RenameVideoFile#" \
			-i undelete.c menuundelete.c

		sed -e "s#RemoveEmptyVideoDirectories#cVideoDirectory::RemoveEmptyVideoDirectories#" \
			-i undelete.c
	fi
}
