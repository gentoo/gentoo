# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/kflickr/kflickr-0.9.1_p1.ebuild,v 1.5 2014/03/21 20:44:34 johu Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="KDE flickr.com image uploading program"
HOMEPAGE="http://kflickr.sourceforge.net/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2 FDL-1.2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DOCS=( AUTHORS README )
