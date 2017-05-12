# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit multilib-minimal toolchain-funcs eutils

DESCRIPTION="Transport Independent RPC library (SunRPC replacement)"
HOMEPAGE="http://libtirpc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2
	mirror://gentoo/${PN}-glibc-nfs.tar.xz"

LICENSE="GPL-2"
SLOT="0/3" # subslot matches SONAME major
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86"
IUSE="ipv6 kerberos static-libs"

RDEPEND="kerberos? ( >=virtual/krb5-0-r1[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]"

PATCHES=(
	"${FILESDIR}/${P}-CVE-2017-8779.patch"
)

src_prepare() {
	cp -r "${WORKDIR}"/tirpc "${S}"/ || die
	epatch "${PATCHES[@]}"
	epatch_user
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		$(use_enable ipv6) \
		$(use_enable kerberos gssapi) \
		$(use_enable static-libs static)
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
	use static-libs || prune_libtool_files
}
