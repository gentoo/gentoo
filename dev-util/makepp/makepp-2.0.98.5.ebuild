# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/makepp/makepp-2.0.98.5.ebuild,v 1.1 2014/09/09 05:12:10 polynomial-c Exp $

EAPI="4"

inherit eutils

MY_PV=${PV/_}
MY_P="${PN}-${MY_PV}"
DESCRIPTION="GNU make replacement"
HOMEPAGE="http://makepp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/2.1/${MY_P}.txz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86 ~x86-linux ~ppc-macos"
IUSE=""

DEPEND=">=dev-lang/perl-5.6.0"

S=${WORKDIR}/${MY_P}

src_unpack() {
	ln -s "${DISTDIR}/${A}" ${P}.tar.xz
	unpack ./${P}.tar.xz
}

src_prepare() {
	# default "all" rule is to run tests :x
	sed -i '/^all:/s:test::' config.pl || die
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
