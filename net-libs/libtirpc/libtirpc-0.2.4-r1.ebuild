# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit toolchain-funcs

DESCRIPTION="Transport Independent RPC library (SunRPC replacement)"
HOMEPAGE="http://libtirpc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2
	mirror://gentoo/${PN}-glibc-nfs.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"
IUSE="ipv6 kerberos static-libs"

RDEPEND="kerberos? ( virtual/krb5 )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig"

src_unpack() {
	unpack ${A}
	cp -r tirpc "${S}"/ || die
}

src_configure() {
	econf \
		$(use_enable ipv6) \
		$(use_enable kerberos gssapi) \
		$(use_enable static-libs static)
}

src_install() {
	default
	insinto /etc
	doins doc/netconfig

	insinto /usr/include/tirpc
	doins -r "${WORKDIR}"/tirpc/*

	# libtirpc replaces rpc support in glibc, so we need it in /
	gen_usr_ldscript -a tirpc

	# makes sure that the linking order for nfs-utils is proper, as
	# libtool would inject a libgssglue dependency in the list.
	use static-libs || find "${ED}" -name '*.la' -delete
}
