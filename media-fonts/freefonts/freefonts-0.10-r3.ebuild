# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="A Collection of Free Type1 Fonts"
HOMEPAGE="http://www.gimp.org"
SRC_URI="mirror://gimp/fonts/${P}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris"
IUSE="X"

S="${WORKDIR}/freefont"

DOCS="README *.license"
FONT_S="${S}"
FONT_SUFFIX="pfb"
