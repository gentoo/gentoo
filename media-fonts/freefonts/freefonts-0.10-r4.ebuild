# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="A Collection of Free Type1 Fonts"
HOMEPAGE="http://www.gimp.org"
SRC_URI="mirror://gimp/fonts/${P}.tar.gz"

LICENSE="freedist free-noncomm all-rights-reserved"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~ia64 ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris"
IUSE="X"
RESTRICT="mirror bindist"

S="${WORKDIR}/freefont"

DOCS="README *.license"
FONT_S="${S}"
FONT_SUFFIX="pfb"
