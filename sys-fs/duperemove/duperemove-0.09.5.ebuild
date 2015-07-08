# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/duperemove/duperemove-0.09.5.ebuild,v 1.1 2015/07/08 19:18:55 mgorny Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Btrfs deduplication utility"
HOMEPAGE="https://github.com/markfasheh/duperemove"
SRC_URI="https://github.com/markfasheh/duperemove/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/glib:2=
	dev-libs/libgcrypt:0="
DEPEND="${RDEPEND}"

src_compile() {
	# CC & CFLAGS are set via = so need to override them
	# LIBRARY_FLAGS are set via += so need to pass them via env
	export LIBRARY_FLAGS="${LDFLAGS}"
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} -Wall"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
}
