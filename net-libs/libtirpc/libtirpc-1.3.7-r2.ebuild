# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic libtool multilib-minimal

DESCRIPTION="Transport Independent RPC library (SunRPC replacement)"
HOMEPAGE="https://sourceforge.net/projects/libtirpc/ https://git.linux-nfs.org/?p=steved/libtirpc.git"
SRC_URI="
	https://downloads.sourceforge.net/${PN}/${P}.tar.bz2
	https://dev.gentoo.org/~sam/distfiles/${PN}-glibc-nfs.tar.xz
"

LICENSE="BSD BSD-2 BSD-4 LGPL-2.1+"
SLOT="0/3" # subslot matches SONAME major
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="kerberos static-libs"

RDEPEND="kerberos? ( >=virtual/krb5-0-r1[${MULTILIB_USEDEP}] )"
DEPEND="
	${RDEPEND}
	elibc_musl? ( sys-libs/queue-standalone )
"
BDEPEND="
	app-arch/xz-utils
	virtual/pkgconfig
"

src_prepare() {
	cp -ra "${WORKDIR}"/tirpc "${S}"/ || die

	default
	elibtoolize
}

multilib_src_configure() {
	# bug #911863
	append-lfs-flags

	local myeconfargs=(
		$(use_enable kerberos gssapi)
		$(use_enable static-libs static)
		KRB5_CONFIG="${ESYSROOT}"/usr/bin/krb5-config
		$(use_enable elibc_musl rpcdb) # For getrpcbyname & al. bug #964394
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs

	insinto /etc
	doins doc/netconfig

	insinto /usr/include/tirpc
	doins -r "${WORKDIR}"/tirpc/*

	# makes sure that the linking order for nfs-utils is proper, as
	# libtool would inject a libgssglue dependency in the list.
	if ! use static-libs ; then
		find "${ED}" -name "*.la" -delete || die
	fi
}
