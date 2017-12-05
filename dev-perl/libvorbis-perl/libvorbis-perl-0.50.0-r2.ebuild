# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=FOOF
DIST_VERSION=0.05
inherit perl-module

DESCRIPTION="Ogg::Vorbis - Perl extension for Ogg Vorbis streams"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="media-libs/libogg
	media-libs/libvorbis"
DEPEND="${RDEPEND}"
