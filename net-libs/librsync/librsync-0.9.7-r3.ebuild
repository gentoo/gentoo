# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/librsync/librsync-0.9.7-r3.ebuild,v 1.11 2013/07/02 07:45:46 ago Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="Flexible remote checksum-based differencing"
HOMEPAGE="http://librsync.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="static-libs"

RDEPEND="dev-libs/popt"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-huge-files.patch
	"${FILESDIR}"/${P}-format-security.patch
	"${FILESDIR}"/${P}-getopt.patch
	"${FILESDIR}"/${P}-implicit-declaration.patch
	)

src_prepare() {
	sed \
		-e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' \
		-i configure.ac || die

	autotools-utils_src_prepare
}
