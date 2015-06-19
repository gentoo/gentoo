# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-forensics/zzuf/zzuf-0.13-r1.ebuild,v 1.4 2012/10/31 18:25:20 kensington Exp $

EAPI=4

inherit autotools eutils

DESCRIPTION="Transparent application input fuzzer"
HOMEPAGE="http://libcaca.zoy.org/wiki/zzuf/"
SRC_URI="http://caca.zoy.org/files/${PN}/${P}.tar.gz
	http://dev.gentoo.org/~cardoe/distfiles/${P}-zzcat-zzat-rename.patch.bz2"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

# fails with sandbox enabled
RESTRICT="test"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_prepare() {
	sed -i -e '/CFLAGS/d' "${S}"/configure.ac \
		|| die "unable to fix the configure.ac"
	sed -i -e 's:noinst_:check_:' "${S}"/test/Makefile.am \
		|| die "unable to fix unconditional test building"

	epatch "${DISTDIR}"/${P}-zzcat-zzat-rename.patch.bz2

	eautoreconf
}

src_configure() {
	# Don't build the static library, as the library is only used for
	# preloading, so there is no reason to build it statically, unless
	# you want to use zzuf with a static-linked executable, which I'm
	# not even sure would be a good idea.
	econf --disable-static
}

src_install() {
	default

	find "${D}" -name '*.la' -delete
}
