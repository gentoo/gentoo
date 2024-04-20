# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Multimedia library used by many games"
HOMEPAGE="https://plib.sourceforge.net/"
SRC_URI="https://plib.sourceforge.net/dist/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ppc sparc x86"

DEPEND="virtual/opengl"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-shared-libs.patch
	"${FILESDIR}"/${P}-X11-r1.patch
	"${FILESDIR}"/${P}-CVE-2011-4620.patch
	"${FILESDIR}"/${P}-CVE-2012-4552.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	append-cxxflags -std=c++03

	# violates strict aliasing rules and is LTO-unsafe: https://bugs.gentoo.org/860048
	# Per upstream in 2021, "PLIB has been obsolete and unmaintained for at LEAST 15 years!!"
	# so this is getting fixed exactly never and getting worse.
	append-cxxflags -fno-strict-aliasing
	filter-lto

	local myconf=(
		--enable-shared
	)

	econf "${myconf[@]}"
}

src_install() {
	default

	dodoc KNOWN_BUGS TODO* NOTICE

	find "${ED}" -name '*.la' -delete || die
}
