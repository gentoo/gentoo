# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="Phil Budne's port of Macro SNOBOL4 in C, for modern machines"
HOMEPAGE="http://www.snobol4.org/csnobol4/"
MY_PN="snobol4"
MY_P="${MY_PN}-${PV}"
#SRC_URI="ftp://ftp.snobol4.org/snobol4/${MY_P}.tar.gz ftp://ftp.ultimate.com/snobol/${MY_P}.tar.gz"
SRC_URI="mirror://snobol4/${MY_P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="sys-devel/gcc
		sys-devel/m4"
RDEPEND=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	#export CFLAGS="-O0 -pipe"
	sed -i.orig -e '/autoconf/s:autoconf:./autoconf:g' \
		-e '/ADD_LDFLAGS/s/-ldb/-lndbm/' \
		"${S}"/configure
	echo "ADD_OPT([${CFLAGS}])" >>${S}/local-config
	echo "ADD_CPPFLAGS([-DUSE_STDARG_H])" >>${S}/local-config
	echo "ADD_CPPFLAGS([-DHAVE_STDARG_H])" >>${S}/local-config
	echo "BINDEST=${EPREFIX}/usr/bin/snobol4" >>${S}/local-config
	echo "MANDEST=${EPREFIX}/usr/share/man/man4/snobol4.1" >>${S}/local-config
	echo "SNOLIB_DIR=${EPREFIX}/usr/lib/snobol4" >>${S}/local-config
}

src_configure() {
	# WARNING
	# The configure script is NOT what you expect
	:
}

src_compile() {
	emake
	emake doc/snobol4.1
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
	dodoc doc/*.ps doc/*.txt doc/*.pdf
}
