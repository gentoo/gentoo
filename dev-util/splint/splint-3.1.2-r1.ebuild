# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools

DESCRIPTION="Check C programs for vulnerabilities and programming mistakes"
HOMEPAGE="http://lclint.cs.virginia.edu/"
SRC_URI="http://www.splint.org/downloads/${P}.src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ppc ppc64 sparc x86"

DEPEND="
	sys-devel/flex
"

src_prepare() {
	# verbose compiler calls
	sed -i -e '/Compiling/d' src/Makefile.am || die
	# automake complains about trailing \
	sed -i -e '1600d' test/Makefile.am || die
	# do not install these header files twice
	sed -i -e '/\$(UnixHeaders)/s|stdio.h stdlib.h||g' lib/Makefile.am || die

	eautoreconf
}

src_configure() {
	# We do not need bison/yacc at all here
	# We definitely need libfl
	BISON=no LEXLIB=-lfl econf
}

src_compile() {
	local subdir
	# skip test/ subdir
	for subdir in src lib imports doc; do
		emake -j1 -C ${subdir}
	done
}

src_test() {
	emake -C test
}
