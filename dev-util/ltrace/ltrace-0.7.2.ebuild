# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils autotools

NUM="3848"

DESCRIPTION="trace library calls made at runtime"
HOMEPAGE="http://ltrace.alioth.debian.org/"
SRC_URI="https://alioth.debian.org/frs/download.php/${NUM}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-alpha amd64 ~arm ~ia64 ~mips ppc ~ppc64 x86"
IUSE="debug selinux test unwind"

RDEPEND="dev-libs/elfutils
	selinux? ( sys-libs/libselinux )
	unwind? ( sys-libs/libunwind )"
DEPEND="${RDEPEND}
	test? ( dev-util/dejagnu )"

src_prepare() {
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
