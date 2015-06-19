# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/lksctp-tools/lksctp-tools-1.0.13.ebuild,v 1.8 2013/05/25 07:44:59 ago Exp $

EAPI=5

inherit eutils multilib flag-o-matic autotools autotools-utils

DESCRIPTION="Tools for Linux Kernel Stream Control Transmission Protocol implementation"
HOMEPAGE="http://lksctp.sourceforge.net/"
SRC_URI="mirror://sourceforge/lksctp/${P}.tar.gz"

LICENSE="|| ( GPL-2+ LGPL-2.1 )"
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE="kernel_linux static-libs"

# This is only supposed to work with Linux to begin with.
DEPEND=">=sys-kernel/linux-headers-2.6"
RDEPEND=""

REQUIRED_USE="kernel_linux"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.0.8-prefix.patch #181602
	epatch "${FILESDIR}"/${P}-build.patch
	sed -i 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.in || die
	eautoreconf
}

src_configure() {
	append-flags -fno-strict-aliasing

	autotools-utils_src_configure
}

DOCS=( AUTHORS ChangeLog INSTALL NEWS README ROADMAP )

src_install() {
	autotools-utils_src_install

	dodoc doc/*txt
	newdoc src/withsctp/README README.withsctp

	# Don't install static library or libtool file, since this is used
	# only as preloadable library.
	use static-libs && rm "${D}"/usr/$(get_libdir)/${PN}/*.a
}
