# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/comic-neue/comic-neue-2.2.ebuild,v 1.2 2015/04/28 09:16:34 yngwin Exp $

EAPI=5
inherit font

DESCRIPTION="Typographically savvy casual script typeface"
HOMEPAGE="http://comicneue.com/"
SRC_URI="http://comicneue.com/${P}.zip"

LICENSE="OFL-1.1"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86 ~mips"
SLOT="0"

DEPEND="app-arch/unzip"

FONT_SUFFIX="otf"
FONT_S=${S}/OTF
