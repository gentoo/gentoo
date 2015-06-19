# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libtaginfo/libtaginfo-0.2.0.ebuild,v 1.3 2014/07/06 13:19:57 mgorny Exp $

EAPI=4

DESCRIPTION="a library for reading media metadata"
HOMEPAGE="https://bitbucket.org/shuerhaaken/libtaginfo"
SRC_URI="https://www.bitbucket.org/shuerhaaken/${PN}/downloads/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/taglib
	!<media-sound/xnoise-0.2.16"
DEPEND="${DEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS README TODO )
