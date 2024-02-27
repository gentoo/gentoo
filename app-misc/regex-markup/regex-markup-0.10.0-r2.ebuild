# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic autotools

DESCRIPTION="A tool to color syslog files as well"
HOMEPAGE="https://www.nongnu.org/regex-markup/"
SRC_URI="https://savannah.nongnu.org/download/regex-markup/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="examples nls"

PATCHES=(
	"${FILESDIR}"/${P}-locale.patch
	"${FILESDIR}"/${PN}-0.10.0-r2-configure.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# fix #570960 by restoring pre-GCC5 inline semantics
	append-cflags -std=gnu89

	local myconf=(
		--enable-largefile
		$(use_enable nls)
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	if use examples; then
		cd examples || die
		emake -f Makefile
	fi
}
