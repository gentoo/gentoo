# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Software package for astronomical image processing"
HOMEPAGE="https://fitsh.net/"
SRC_URI="https://fitsh.net/download/fitsh/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.4-makefile.patch
)

src_prepare() {
	default

	local file
	for file in man/*.gz ; do
		gzip -d "${file}" || die
	done

	eautoreconf
}
