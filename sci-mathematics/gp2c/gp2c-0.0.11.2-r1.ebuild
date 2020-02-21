# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}-"$(ver_rs  3 'pl')
DESCRIPTION="A GP to C translator"
HOMEPAGE="http://pari.math.u-bordeaux.fr/"
SRC_URI="http://pari.math.u-bordeaux.fr/pub/pari/GP2C/${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

# Perl is run on the build host to compile the descriptions in desc/,
# see for example desc/Makefile.am.
BDEPEND="dev-lang/perl"

# This is the first version of pari to put pari.cfg where we expect it.
DEPEND=">=sci-mathematics/pari-2.11.2"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure(){
	econf --with-paricfg="${EPREFIX}/usr/share/pari/pari.cfg"
}
