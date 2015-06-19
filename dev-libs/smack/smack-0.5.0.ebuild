# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/smack/smack-0.5.0.ebuild,v 1.1 2013/01/28 06:22:10 patrick Exp $

EAPI=4
DESCRIPTION="low-level IO storage which packs data into sorted compressed blobs"
HOMEPAGE="http://reverbrain.com/smack/"
SRC_URI="http://dev.gentoo.org/~patrick/${P}.tar.bz2"

inherit eutils cmake-utils

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/snappy"
RDEPEND="${DEPEND}"
