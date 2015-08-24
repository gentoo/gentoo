# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

BASE_PV="1.0_p20120915"

DESCRIPTION="Userspace Software Suspend and S2Ram"
HOMEPAGE="http://suspend.sourceforge.net/"
SRC_URI="https://dev.gentoo.org/~bircoph/distfiles/${PN}-${BASE_PV}.tar.xz
	https://dev.gentoo.org/~bircoph/patches/${P}.patch.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="crypt fbsplash +lzo threads"

RDEPEND="
	dev-libs/libx86
	crypt? (
		>=dev-libs/libgcrypt-1.6.3:0[static-libs]
		dev-libs/libgpg-error[static-libs] )
	fbsplash? ( >=media-gfx/splashutils-1.5.4.4-r6 )
	lzo? ( >=dev-libs/lzo-2[static-libs] ) "
DEPEND="${RDEPEND}
	>=dev-lang/perl-5.10
	>=sys-apps/pciutils-2.2.4
	virtual/pkgconfig"

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${WORKDIR}/${P}.patch"
	eautoreconf
}

src_configure() {
	econf \
		--docdir="/usr/share/doc/${PF}" \
		$(use_enable crypt encrypt) \
		$(use_enable fbsplash) \
		$(use_enable lzo compress) \
		$(use_enable threads)
}

src_install() {
	dodir etc
	emake DESTDIR="${D}" install
	rm "${D}/usr/share/doc/${PF}"/COPYING* || die
}

pkg_postinst() {
	elog "In order to make this package work with genkernel see:"
	elog "https://bugs.gentoo.org/show_bug.cgi?id=156445"
}
