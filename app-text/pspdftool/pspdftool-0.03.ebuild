# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="Tool for prepress preparation of PDF and PostScript documents"
HOMEPAGE="https://sourceforge.net/projects/pspdftool"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="zlib"

RDEPEND="zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	# -Werror=strict-aliasing; do not trust for LTO-safety either.
	# https://bugs.gentoo.org/855023
	# Upstream is dead for nearly a decade. Not forwarded.
	append-flags -fno-strict-aliasing
	filter-lto

	econf $(use_with zlib)
}

src_install() {
	default
	rm -rf "${ED}"/usr/share/doc/${PN}* || die
}
