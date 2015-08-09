# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils flag-o-matic

DESCRIPTION="A fake root environment by means of LD_PRELOAD and SysV IPC (or TCP) trickery"
HOMEPAGE="http://packages.qa.debian.org/f/fakeroot.html"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${P/-/_}.orig.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ppc sparc x86 ~amd64-linux ~x86-linux"
IUSE="acl debug static-libs test"

DEPEND="acl? ( sys-apps/acl )
	test? ( app-arch/sharutils )
	sys-libs/libcap"

DOCS="AUTHORS BUGS DEBUG README doc/README.saving"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.19-no-acl_h.patch
}

src_configure() {
	export ac_cv_header_sys_acl_h=$(usex acl)

	use debug && append-cppflags "-DLIBFAKEROOT_DEBUGGING"
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
