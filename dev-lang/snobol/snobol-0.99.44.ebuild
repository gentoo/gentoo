# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/snobol/snobol-0.99.44.ebuild,v 1.5 2012/11/27 19:41:40 ulm Exp $

DESCRIPTION="Phil Budne's port of Macro SNOBOL4 in C, for modern machines"
HOMEPAGE="http://www.snobol4.org/csnobol4/"
#SRC_URI="mirror://snobol4/${P}.tar.gz"
MY_PN="snobol4"
MY_P="${MY_PN}-${PV}"
SRC_URI="ftp://ftp.snobol4.org/snobol4/beta/${MY_P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="sys-devel/gcc
		sys-devel/m4"
RDEPEND=""

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	sed '/autoconf/s:autoconf:./autoconf:g' -i ${S}/configure
	echo "ADD_OPT([${CFLAGS}])" >>${S}/local-config
	echo "ADD_CPPFLAGS([-DUSE_STDARG_H])" >>${S}/local-config
	echo "ADD_CPPFLAGS([-DHAVE_STDARG_H])" >>${S}/local-config
	echo "BINDEST=/usr/bin/snobol4" >>${S}/local-config
	echo "MANDEST=/usr/share/man/man4/snobol4.1" >>${S}/local-config
	echo "SNOLIB_DIR=/usr/lib/snobol4" >>${S}/local-config
}

src_compile() {
	# WARNING
	# The configure script is NOT what you expect
	emake || die "emake failed"
	emake doc/snobol4.1 || die "emake doc/snobol4.1 failed"
}

src_install() {
	into /usr
	newbin xsnobol4 snobol4
	dodir /usr/lib/snobol4
	insinto /usr/lib/snobol4
	doins snolib.a snolib/bq.sno

	doman doc/*.1
	dohtml doc/*.html
	rm doc/*.html
	dodoc doc/*.ps doc/*.doc doc/*.txt doc/*.pdf
}
