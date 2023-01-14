# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic multilib-minimal toolchain-funcs usr-ldscript

DESCRIPTION="Transport Independent RPC library (SunRPC replacement)"
HOMEPAGE="https://sourceforge.net/projects/libtirpc/ https://git.linux-nfs.org/?p=steved/libtirpc.git"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2
	mirror://gentoo/${PN}-glibc-nfs.tar.xz"

LICENSE="BSD BSD-2 BSD-4 LGPL-2.1+"
SLOT="0/3" # subslot matches SONAME major
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="kerberos static-libs"

RDEPEND="kerberos? ( >=virtual/krb5-0-r1[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	elibc_musl? ( sys-libs/queue-standalone )"
BDEPEND="
	app-arch/xz-utils
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-release-version.patch
)

src_prepare() {
	cp -ra "${WORKDIR}"/tirpc "${S}"/ || die

	default
}

multilib_src_configure() {
	# ideally we want !tc-ld-is-bfd for best future-proofing, but it needs
	# https://github.com/gentoo/gentoo/pull/28355
	# mold needs this too but right now tc-ld-is-mold is also not available
	if tc-ld-is-lld; then
		append-ldflags -Wl,--undefined-version
	fi

	local myeconfargs=(
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
