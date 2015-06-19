# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/ltrace/ltrace-0.7.3.ebuild,v 1.1 2013/09/18 20:47:38 radhermit Exp $

EAPI=5

inherit eutils autotools

NUM="3947"

DESCRIPTION="trace library calls made at runtime"
HOMEPAGE="http://ltrace.alioth.debian.org/"
SRC_URI="https://alioth.debian.org/frs/download.php/file/${NUM}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~x86"
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
