# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/ogg-vorbis-header/ogg-vorbis-header-0.30.0-r1.ebuild,v 1.2 2015/02/25 23:21:13 dilfridge Exp $

EAPI=5

MY_PN=Ogg-Vorbis-Header
MODULE_AUTHOR=DBP
MODULE_VERSION=0.03
inherit perl-module

DESCRIPTION="This module presents an object-oriented interface to Ogg Vorbis Comments and Information"

SLOT="0"
LICENSE="|| ( GPL-2 GPL-3 ) LGPL-2" # GPL-2+
KEYWORDS="alpha amd64 ia64 ~ppc sparc x86"
IUSE=""

RDEPEND="
	|| ( <=dev-perl/Inline-0.560.0 dev-perl/Inline-C )
	media-libs/libogg
	media-libs/libvorbis
"
DEPEND="${RDEPEND}"

SRC_TEST="do"
MAKEOPTS="${MAKEOPTS} -j1"
