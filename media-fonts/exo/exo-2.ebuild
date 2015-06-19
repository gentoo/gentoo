# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/exo/exo-2.ebuild,v 1.2 2015/04/28 09:48:24 yngwin Exp $

EAPI=5
inherit font

DESCRIPTION="A geometric sans-serif font with a technological feel"
HOMEPAGE="http://ndiscovered.com/exo-2/"
SRC_URI="http://dev.gentoo.org/~yngwin/distfiles/${P}.tar.xz"
# repackaged from two upstream zips (exo-2, exo condensed & expanded) + license

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 x86"
IUSE=""

FONT_SUFFIX="otf"
