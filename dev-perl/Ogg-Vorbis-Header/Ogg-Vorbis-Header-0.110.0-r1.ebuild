# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DAVECROSS
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="An object-oriented interface to Ogg Vorbis information and comment fields"

SLOT="0"
LICENSE="GPL-2+ LGPL-2"
KEYWORDS="~alpha amd64 ~ppc ~sparc x86"

RDEPEND="
	>=dev-perl/Inline-0.440.0
	dev-perl/Inline-C
	media-libs/libogg
	media-libs/libvorbis
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.110.0-c99.patch
)
