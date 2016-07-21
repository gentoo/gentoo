# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit multilib

DESCRIPTION="Set of tiny linux utilities"
HOMEPAGE="http://www.skarnet.org/software/s6-linux-utils/"
SRC_URI="http://www.skarnet.org/software/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static"

DEPEND="
	static? ( >=dev-libs/skalibs-2.3.8.0[static-libs] )
	!static? ( >=dev-libs/skalibs-2.3.8.0 )
	"
RDEPEND="
	!static? ( >=dev-libs/skalibs-2.3.8.0 )
	"

HTML_DOCS="doc/."

src_prepare()
{
	# Remove QA warning about LDFLAGS addition
	sed -i "s~tryldflag LDFLAGS_AUTO -Wl,--hash-style=both~:~" "${S}/configure" || die

	eapply_user
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
