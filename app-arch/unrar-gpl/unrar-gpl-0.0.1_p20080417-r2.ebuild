# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit autotools flag-o-matic

DESCRIPTION="Free rar unpacker for old (pre v3) rar files"
HOMEPAGE="http://home.gna.org/unrar/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""
DEPEND="!elibc_glibc? ( dev-libs/argp dev-libs/gnulib )"

DOCS="AUTHORS README"

S=${WORKDIR}/${PN/-gpl}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.0.1-solaris.patch
	sed -i configure.ac -e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' || die
	eautoreconf

	if [[ ${CHOST} == *-aix* || ${CHOST} == *-solaris* ]]; then
		append-cppflags -I"${EPREFIX}"/usr/$(get_libdir)/gnulib/include
		append-ldflags -L"${EPREFIX}"/usr/$(get_libdir)/gnulib/lib
		append-libs -lgnu
	fi
}
src_configure() { econf --program-suffix="-gpl"; }
