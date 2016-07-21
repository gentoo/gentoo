# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib

DESCRIPTION="skarnet.org's small and secure supervision software suite"
HOMEPAGE="http://www.skarnet.org/software/s6/"
SRC_URI="http://www.skarnet.org/software/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static"

DEPEND=">=sys-devel/make-4.0
	static? (
		>=dev-lang/execline-2.1.1.0[static-libs]
		>=dev-libs/skalibs-2.3.2.0[static-libs]
	)
	!static? (
		>=dev-lang/execline-2.1.1.0
		>=dev-libs/skalibs-2.3.2.0
	)
	"
RDEPEND="
	!static? (
		>=dev-lang/execline-2.1.1.0
		>=dev-libs/skalibs-2.3.2.0
	)
	"

src_prepare()
{
	# Remove QA warning about LDFLAGS addition
	sed -i "s~tryldflag LDFLAGS_AUTO -Wl,--hash-style=both~:~" "${S}/configure" || die
}

src_configure()
{
	econf \
		$(use_enable !static shared) \
		$(use_enable static allstatic) \
		$(use_enable static) \
		--bindir=/bin \
		--sbindir=/sbin \
		--dynlibdir=/$(get_libdir) \
		--libdir=/usr/$(get_libdir)/${PN} \
		--datadir=/etc \
		--sysdepdir=/usr/$(get_libdir)/${PN} \
		--with-dynlib=/$(get_libdir) \
		--with-sysdeps=/usr/$(get_libdir)/skalibs
}

src_compile()
{
	emake DESTDIR="${D}"
}

src_install()
{
	default
	dodoc -r examples
	dohtml -r doc/*
}
