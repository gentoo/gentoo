# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=${PV/_}
MY_P="${PN}-${MY_PV}"
DESCRIPTION="GNU make replacement"
HOMEPAGE="http://makepp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/2.1/${MY_P}.txz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86 ~x86-linux ~ppc-macos"
IUSE=""

DEPEND="dev-lang/perl:="

S=${WORKDIR}/${MY_P}

src_prepare() {
	# default "all" rule is to run tests :x
	sed -i '/^all:/s:test::' config.pl || die
	sed -i 's/^  my $gzip =.*/  my $gzip = "";/' install.pl || die
	default
}

src_configure() {
	# not an autoconf configure script
	./configure \
		--prefix="${EPREFIX}"/usr \
		--bindir="${EPREFIX}"/usr/bin \
		--htmldir="${EPREFIX}"/usr/share/doc/${PF}/html \
		--mandir="${EPREFIX}"/usr/share/man \
		--datadir="${EPREFIX}"/usr/share/makepp \
		|| die "configure failed"
}

src_test() {
	# work around https://bugzilla.samba.org/show_bug.cgi?id=8728
	export CCACHE_UNIFY=1
	ROOT= default
}
