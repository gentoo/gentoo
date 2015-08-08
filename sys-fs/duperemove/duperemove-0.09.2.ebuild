# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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

src_prepare() {
	# https://github.com/markfasheh/duperemove/issues/53#issuecomment-89796552
	sed -i -e '/glib2_mutex_unlock/s:mutex_lock:mutex_unlock:' duperemove.c || die
}

src_compile() {
	# CC & CFLAGS are set via = so need to override them
	# LIBRARY_FLAGS are set via += so need to pass them via env
	export LIBRARY_FLAGS="${LDFLAGS}"
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} -Wall"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
}
