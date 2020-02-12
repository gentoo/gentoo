# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="Flexible remote checksum-based differencing"
HOMEPAGE="https://librsync.github.io/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/1"
KEYWORDS="~alpha amd64 arm ~hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="static-libs"

RDEPEND="dev-libs/popt"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-huge-files.patch
	"${FILESDIR}"/${P}-format-security.patch
	"${FILESDIR}"/${P}-getopt.patch
	"${FILESDIR}"/${P}-implicit-declaration.patch
	"${FILESDIR}"/${P}-fix-testsuite.patch
	)

src_prepare() {
	sed \
		-e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' \
		-i configure.ac || die

	autotools-utils_src_prepare
}
