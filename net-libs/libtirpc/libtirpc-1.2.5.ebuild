# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal toolchain-funcs usr-ldscript

DESCRIPTION="Transport Independent RPC library (SunRPC replacement)"
HOMEPAGE="https://sourceforge.net/projects/libtirpc/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2
	mirror://gentoo/${PN}-glibc-nfs.tar.xz"

LICENSE="GPL-2"
SLOT="0/3" # subslot matches SONAME major
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="ipv6 kerberos static-libs"

RDEPEND="kerberos? ( >=virtual/krb5-0-r1[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/xz-utils
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]"

src_prepare() {
	cp -r "${WORKDIR}"/tirpc "${S}"/ || die
	default
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable ipv6)
		$(use_enable kerberos gssapi)
		$(use_enable static-libs static)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install() {
	default

	# libtirpc replaces rpc support in glibc, so we need it in /
	gen_usr_ldscript -a tirpc
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
