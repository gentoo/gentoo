# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Correctly read (or write) a region of a block device"
HOMEPAGE="http://devio.sourceforge.net/"
SRC_URI="mirror://sourceforge/devio/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 arm x86"

src_prepare() {
	default

	# Clang 16
	eautoreconf
}
