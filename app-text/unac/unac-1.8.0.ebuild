# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit autotools eutils

DESCRIPTION="Library and command-line tool for removing accents from characters"
HOMEPAGE="http://www.nongnu.org/unac/"
SRC_URI="mirror://debian/pool/main/u/unac/${P/-/_}.orig.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/libiconv"
DEPEND="${RDEPEND}
	test? ( dev-lang/perl )"

S="${WORKDIR}/${P}.orig"

src_prepare() {
	epatch "${FILESDIR}/${P}-debian-gcc-4.4-bug-556379.patch"
	epatch "${FILESDIR}/${P}-automake-1.13.1.patch"
	# otherwise automake will fail
	touch config.rpath
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	DOCS="AUTHORS ChangeLog NEWS README THANKS"
	default
	prune_libtool_files
}

pkg_postinst() {
	einfo "Examples of using unaccent from the command line:"
	einfo "unaccent utf8 été"
	einfo "echo -e '\\\\0303\\\\0251t\\\\0303\\\\0251' | unaccent utf8"
	einfo "unaccent ISO-8859-1 < myfile > myfile.unaccent"
	einfo
	einfo "See man unaccent and man unac for more information."
}
