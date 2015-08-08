# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils toolchain-funcs

DESCRIPTION="Generic tool for pairwise sequence comparison"
HOMEPAGE="http://www.ebi.ac.uk/~guy/exonerate/"
SRC_URI="http://www.ebi.ac.uk/~guy/exonerate/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-macos ~x64-macos"
IUSE="utils test threads"

REQUIRED_USE="test? ( utils )"

DEPEND="dev-libs/glib:2"
RDEPEND="${DEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD=1

PATCHES=( "${FILESDIR}"/${P}-asneeded.patch )

src_prepare() {
	tc-export CC
	sed \
		-e 's: -O3 -finline-functions::g' \
		-i configure.in || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable utils utilities)
		$(use_enable threads pthreads)
		--enable-largefile
		--enable-glib2
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	doman doc/man/man1/*.1
}
