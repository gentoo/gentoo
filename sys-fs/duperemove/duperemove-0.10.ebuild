# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Btrfs deduplication utility"
HOMEPAGE="https://github.com/markfasheh/duperemove"
SRC_URI="https://github.com/markfasheh/duperemove/archive/v${PV}.tar.gz -> ${P}.tar.gz"

# includes code from libbloom, xxhash (BSD-2)
# includes code from polarssl (GPL-2+)
LICENSE="GPL-2 GPL-2+ BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-db/sqlite:3=
	dev-libs/glib:2="
DEPEND="${RDEPEND}"

src_compile() {
	# CC & CFLAGS are set via = so need to override them
	# LIBRARY_FLAGS are set via += so need to pass them via env
	local -x LIBRARY_FLAGS="${LDFLAGS}"
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} -Wall"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
}
