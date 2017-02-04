# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit eutils

DESCRIPTION="A C implementation of MD6"
HOMEPAGE="http://groups.csail.mit.edu/cis/md6"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

PATCHES=(
	"${FILESDIR}/${P}-ldflags.patch"
	"${FILESDIR}/${P}-cflags.patch"
	"${FILESDIR}/${P}-format-security.patch"
)
