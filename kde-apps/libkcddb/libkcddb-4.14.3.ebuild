# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE library for CDDB"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug musicbrainz"

# tests require network access and compare static data with online data
# bug 280996
RESTRICT=test

DEPEND="
	musicbrainz? ( media-libs/musicbrainz:5 )
"
RDEPEND="${DEPEND}"

KMSAVELIBS="true"

src_prepare() {
	kde4-base_src_prepare

	if ! use handbook ; then
		pushd kcmcddb > /dev/null
		comment_add_subdirectory doc
		popd > /dev/null
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with musicbrainz MusicBrainz5)
	)

	kde4-base_src_configure
}
