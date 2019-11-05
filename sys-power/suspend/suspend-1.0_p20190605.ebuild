# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

BASE_PV="1.0_p20120915"

DESCRIPTION="Userspace Software Suspend and S2Ram"
HOMEPAGE="http://suspend.sourceforge.net
https://github.com/bircoph/suspend"
SRC_URI="https://dev.gentoo.org/~bircoph/distfiles/${PN}-${BASE_PV}.tar.xz
	https://dev.gentoo.org/~bircoph/patches/${P}.patch.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="crypt +lzo threads"

RDEPEND="
	dev-libs/libx86
	>=sys-apps/pciutils-2.2.4
	crypt? (
		>=dev-libs/libgcrypt-1.6.3:0[static-libs]
		dev-libs/libgpg-error[static-libs] )
	lzo? ( >=dev-libs/lzo-2[static-libs] ) "
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-lang/perl-5.10
	virtual/pkgconfig"

S="${WORKDIR}/${PN}"

PATCHES=( "${WORKDIR}/${P}.patch" )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--docdir="/usr/share/doc/${PF}" \
		--disable-fbsplash \
		$(use_enable crypt encrypt) \
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
