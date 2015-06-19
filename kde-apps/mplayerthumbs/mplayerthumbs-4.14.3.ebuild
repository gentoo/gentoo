# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-apps/mplayerthumbs/mplayerthumbs-4.14.3.ebuild,v 1.1 2015/06/04 18:44:39 kensington Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="A Thumbnail Generator for Video Files on KDE filemanagers"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
	$(add_kdeapps_dep kdebase-kioslaves)
"

src_configure() {
	local mycmakeargs=(
		-DENABLE_PHONON_SUPPORT=ON
	)

	kde4-base_src_configure
}
