# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils

DESCRIPTION="a library for reading media metadata"
HOMEPAGE="https://bitbucket.org/shuerhaaken/libtaginfo"
SRC_URI="https://www.bitbucket.org/shuerhaaken/${PN}/downloads/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="media-libs/taglib
	!<media-sound/xnoise-0.2.16"
DEPEND="${DEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS README TODO )
