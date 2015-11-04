# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils autotools

DESCRIPTION="A C++ support library for libpcre"
HOMEPAGE="http://www.daemon.de/PCRE"
SRC_URI="http://www.daemon.de/files/mirror/ftp.daemon.de/scip/Apps/${PN}/${P}.tar.gz
	mirror://gentoo/${P}-patches.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 s390 sh sparc x86"
IUSE="static-libs"

DEPEND="dev-libs/libpcre"
RDEPEND="${DEPEND}"

src_prepare() {
	EPATCH_SUFFIX="patch" \
	EPATCH_SOURCE="${WORKDIR}/${P}-patches" \
	EPATCH_FORCE="yes" \
	epatch

	sed -i 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.in || die #467670

	# Upstream is kind of dead, so handle the rename ourselves.
	mv configure.{in,ac} || die

	# Disable examples which we never run/install.
	echo > examples/Makefile.am || die

	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || find "${ED}"/usr -name 'lib*.la' -delete

	dohtml -r doc/html/.
	doman doc/man/man3/Pcre.3

	rm -rf "${ED}/usr/doc"
}
