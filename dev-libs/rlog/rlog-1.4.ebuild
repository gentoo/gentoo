# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="A C++ logging library"
HOMEPAGE="https://www.arg0.net/rlog"
SRC_URI="https://rlog.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc sparc x86"
IUSE=""

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.7-gcc-4.3.patch
	"${FILESDIR}"/${PN}-1.4-fix-build-system.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default

	# package installs .pc files
	find "${D}" -name '*.la' -delete || die
}
