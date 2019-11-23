# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_PV=${PV}
MY_RC=${PV}
S=${WORKDIR}/${PN}-${MY_PV}

DESCRIPTION="Sender Rewriting Scheme library for use with Exim"
HOMEPAGE="http://opsec.eu/src/srs/"
SRC_URI="https://opsec.eu/src/srs/libsrs_alt-${MY_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86"
IUSE="static-libs"

RDEPEND="!dev-perl/Mail-SRS"

src_prepare() {
	eapply "${FILESDIR}"/${P}-ftime.patch

	# add missing header
	sed -i -e '/timeb.h>/ a #include <stdlib.h>' test.c

	eapply_user

	eautoreconf
}

src_configure() {
	# Since the primary intended consumers of this library are MTAs,
	# use non-standard separator characters (--with-base64compat).
	# This breaks "SRS Compliancy", which is a rough standard at
	# best.
	econf --with-base64compat
}

src_compile() {
	# Makefile rules are h0rk3ned, but this is such a tiny package, that
	# it hardly makes sense to fix this.
	emake -j1
}

src_install() {
	default
	dodoc "${S}"/MTAs/README.EXIM

	use static-libs || rm "${ED}"/usr/$(get_libdir)/libsrs_alt.a
}
