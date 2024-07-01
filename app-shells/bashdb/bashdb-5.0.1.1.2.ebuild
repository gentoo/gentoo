# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}-${PV:0:3}-${PV:4}"
DESCRIPTION="bash source code debugging"
HOMEPAGE="http://bashdb.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/bashdb/${MY_P}.tar.bz2
	test? ( mirror://gentoo/30/bashdb-4.4-1.0.0-missing-test-files.tar.xz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND=">=app-shells/bash-5
	!>=app-shells/bash-${PV:0:1}.$((${PV:2:1}+1))"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	if use test ; then
		einfo "Copying missing files ..."
		# https://sourceforge.net/p/bashdb/bugs/52/
		cp -vafn "${WORKDIR}"/missing-files/* "${S}"/test || die
	fi

	default

	# We don't install this, so don't bother building it. #468044
	sed -i 's:texi2html:true:' doc/Makefile.in || die
}

src_configure() {
	# This path matches the bash sources.  If we ever change bash,
	# we'll probably have to change this to match.  #591994
	econf --with-dbg-main='$(PKGDATADIR)/bashdb-main.inc'
}
