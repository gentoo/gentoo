# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils eutils

DESCRIPTION="Simple MTP fuse filesystem driver"
HOMEPAGE="https://github.com/phatina/simple-mtpfs"
SRC_URI="mirror://github/phatina/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

CDEPEND="media-libs/libmtp
		>=sys-fs/fuse-2.8"

DEPEND="virtual/pkgconfig
		${CDEPEND}"

RDEPEND="${CDEPEND}"

AUTOTOOLS_AUTORECONF=1
