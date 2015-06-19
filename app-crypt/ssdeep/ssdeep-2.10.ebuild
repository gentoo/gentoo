# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/ssdeep/ssdeep-2.10.ebuild,v 1.1 2014/02/01 07:46:18 radhermit Exp $

EAPI=5
AUTOTOOLS_AUTORECONF=1

inherit autotools-multilib

DESCRIPTION="Computes context triggered piecewise hashes (fuzzy hashes)"
HOMEPAGE="http://ssdeep.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DOCS=( AUTHORS ChangeLog FILEFORMAT NEWS README TODO )

PATCHES=( "${FILESDIR}"/${P}-shared.patch )
