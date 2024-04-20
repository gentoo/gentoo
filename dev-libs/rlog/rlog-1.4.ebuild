# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A C++ logging library"
HOMEPAGE="https://www.arg0.net/rlog"
SRC_URI="https://rlog.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc sparc x86"
IUSE="valgrind"

DEPEND="valgrind? ( dev-debug/valgrind )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.7-gcc-4.3.patch
	"${FILESDIR}"/${PN}-1.4-fix-build-system.patch
	"${FILESDIR}"/${PN}-1.4-autoconf-2.70.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable valgrind)
}

src_install() {
	default

	# package installs .pc files
	find "${ED}" -name '*.la' -delete || die
}
