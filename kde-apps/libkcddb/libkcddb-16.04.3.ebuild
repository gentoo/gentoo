# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE library for CDDB"
KEYWORDS="~amd64 ~arm ~x86"
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
		pushd kcmcddb > /dev/null || die
		cmake_comment_add_subdirectory doc
		popd > /dev/null || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DWITH_MusicBrainz5=$(usex musicbrainz)
	)

	kde4-base_src_configure
}
