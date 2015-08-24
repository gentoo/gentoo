# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
DESCRIPTION="low-level IO storage which packs data into sorted compressed blobs"
HOMEPAGE="http://reverbrain.com/smack/"
SRC_URI="https://dev.gentoo.org/~patrick/${P}.tar.bz2"

inherit eutils cmake-utils

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/snappy"
RDEPEND="${DEPEND}"
