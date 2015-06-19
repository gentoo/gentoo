# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/ltrace/ltrace-0.7.3_p4.ebuild,v 1.2 2014/05/29 00:57:22 jer Exp $

EAPI=5
inherit autotools eutils

LTRACE_V=${PV/_p*/}
DB_V=${PV/*_p/}

DESCRIPTION="trace library calls made at runtime"
HOMEPAGE="http://ltrace.alioth.debian.org/"
SRC_URI="
	mirror://debian/pool/main/l/${PN}/${PN}_${LTRACE_V}.orig.tar.bz2
	mirror://debian/pool/main/l/${PN}/${PN}_${LTRACE_V}-${DB_V}.debian.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug selinux test unwind"

RDEPEND="dev-libs/elfutils
	selinux? ( sys-libs/libselinux )
	unwind? ( sys-libs/libunwind )"
DEPEND="${RDEPEND}
	test? ( dev-util/dejagnu )"

S=${WORKDIR}/${PN}-${LTRACE_V}

src_prepare() {
	epatch "${WORKDIR}"/debian/patches/[0-9]*
	sed -i '/^dist_doc_DATA/d' Makefile.am || die
	eautoreconf
}

src_configure() {
	ac_cv_header_selinux_selinux_h=$(usex selinux) \
	ac_cv_lib_selinux_security_get_boolean_active=$(usex selinux) \
	econf \
		--disable-werror \
		$(use_enable debug) \
		$(use_with unwind libunwind)
}
