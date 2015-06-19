# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/jsmath-extra-light/jsmath-extra-light-1.0.ebuild,v 1.2 2009/12/14 17:27:06 bicatali Exp $

inherit font

DESCRIPTION="Extra raster fonts for jsmath, light version"
HOMEPAGE="http://www.math.union.edu/~dpvc/jsMath/download/extra-fonts/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND="media-fonts/jsmath
	!media-fonts/jsmath-extra-dark"

FONT_SUFFIX="ttf"
