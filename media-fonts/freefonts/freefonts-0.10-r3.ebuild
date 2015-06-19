# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/freefonts/freefonts-0.10-r3.ebuild,v 1.12 2010/01/01 18:05:20 fauli Exp $

inherit font

DESCRIPTION="A Collection of Free Type1 Fonts"
SRC_URI="mirror://gimp/fonts/${P}.tar.gz"
HOMEPAGE="http://www.gimp.org"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~sparc-solaris"
SLOT="0"
LICENSE="freedist"
IUSE="X"

FONT_S=${WORKDIR}/freefont
S=${FONT_S}

FONT_SUFFIX="pfb"
DOCS="README *.license"
