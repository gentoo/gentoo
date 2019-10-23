# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="A tool to write command line option parsing code for C programs"
HOMEPAGE="https://www.gnu.org/software/gengetopt/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc ppc64 x86 ~x64-cygwin ~amd64-linux ~x86-linux ~sparc-solaris ~sparc64-solaris"
PATCHES=(
	"${FILESDIR}"/${PN}-2.22.6-docdirs.patch
)

src_prepare() {
	default

	sed -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' -i configure.ac || die
	sed -e '/gengetoptdoc_DATA/d' -i Makefile.am || die

	eautoreconf
}

src_configure() {
	econf --docdir="${EPREFIX}"/usr/share/doc/${PF}
}
