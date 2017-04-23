# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils prefix

DESCRIPTION="Converts source files to colored HTML output"
HOMEPAGE="http://www.palfrader.org/code2html/"
SRC_URI="http://www.palfrader.org/code2html/all/${P}.tar.gz
	mirror://gentoo/${P}-gentoo_patches.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND=""
RDEPEND=">=dev-lang/perl-5"

src_prepare() {
	# Be consistent in color codes (bug #119406)
	epatch "${WORKDIR}"/${P}-lowercase_color_codes.patch

	# Improved C++ support (bug #133159)
	epatch "${WORKDIR}"/${P}-cpp_keywords.patch

	# Improved Ada support (bug #133176)
	epatch "${WORKDIR}"/${P}-ada_identifiers.patch

	# For prefix paths
	epatch "${FILESDIR}"/${P}-prefix.patch
	eprefixify code2html

	# For newer Perl, bug 523610
	epatch "${FILESDIR}"/${P}-scalar.patch
}

src_install() {
	dobin code2html
	dodoc ChangeLog CREDITS README
	doman code2html.1
}
