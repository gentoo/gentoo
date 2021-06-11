# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Library and command-line tool for removing accents from characters"
HOMEPAGE="http://www.nongnu.org/unac/"
SRC_URI="mirror://debian/pool/main/u/unac/${P/-/_}.orig.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/libiconv"
DEPEND="${RDEPEND}
	test? ( dev-lang/perl )"

S="${WORKDIR}/${P}.orig"

PATCHES=(
	"${FILESDIR}"/${P}-debian-gcc-4.4-bug-556379.patch
	"${FILESDIR}"/${P}-automake-1.13.1.patch
)

src_prepare() {
	default
	rm README.Debian || die
	# otherwise automake will fail
	touch config.rpath
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
