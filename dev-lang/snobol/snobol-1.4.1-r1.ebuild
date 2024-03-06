# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

MY_P="${PN}4-${PV}"
DESCRIPTION="Phil Budne's port of Macro SNOBOL4 in C, for modern machines"
HOMEPAGE="http://www.snobol4.org/csnobol4/"
SRC_URI="ftp://ftp.snobol4.org/snobol/old/${MY_P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="sys-libs/gdbm[berkdb]"
RDEPEND="${DEPEND}"
BDEPEND="sys-devel/m4"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_prepare() {
	default

	# bug #855650
	append-flags -fno-strict-aliasing
	filter-lto

	sed -i -e '/autoconf/s:autoconf:./autoconf:g' configure || die
	sed -i -e 's/$(INSTALL) -s/$(INSTALL)/' Makefile2.m4 || die
	echo "ADD_OPT([${CFLAGS}])" >> local-config || die
	echo "ADD_CPPFLAGS([-DUSE_STDARG_H])" >> local-config || die
	echo "ADD_CPPFLAGS([-DHAVE_STDARG_H])" >> local-config || die

	# this cannot work and will cause funny sandbox violations
	sed -i -e 's~/usr/bin/emerge info~~' timing || die "Failed to exorcise the sandbox violations"
}

src_configure() {
	tc-export CC
	./configure --prefix="${EPREFIX}/usr" \
		--snolibdir="${EPREFIX}/usr/lib/snobol4" \
		--mandir="${EPREFIX}/usr/share/man" \
		--add-cflags="${CFLAGS}" || die
}

src_install() {
	emake DESTDIR="${D}" install

	rm "${ED}"/usr/lib/snobol4/{load.txt,README} || die

	dodoc doc/*txt
	use doc && dodoc -r doc/*html
}
