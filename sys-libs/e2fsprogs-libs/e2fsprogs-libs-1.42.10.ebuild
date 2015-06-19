# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/e2fsprogs-libs/e2fsprogs-libs-1.42.10.ebuild,v 1.17 2015/05/25 10:21:48 vapier Exp $

EAPI="4"

case ${PV} in
*_pre*) UP_PV="${PV%_pre*}-WIP-${PV#*_pre}" ;;
*)      UP_PV=${PV} ;;
esac

inherit toolchain-funcs eutils multilib-minimal

DESCRIPTION="e2fsprogs libraries (common error and subsystem)"
HOMEPAGE="http://e2fsprogs.sourceforge.net/"
SRC_URI="mirror://sourceforge/e2fsprogs/${PN}-${UP_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~m68k-mint ~x86-solaris"
IUSE="nls static-libs"

RDEPEND="!sys-libs/com_err
	!sys-libs/ss
	!<sys-fs/e2fsprogs-1.41.8
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20130224-r12
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"
DEPEND="nls? ( sys-devel/gettext )
	virtual/pkgconfig"

S=${WORKDIR}/${P%_pre*}

src_prepare() {
	printf 'all:\n%%:;@:\n' > doc/Makefile.in # don't bother with docs #305613
	epatch "${FILESDIR}"/${PN}-1.42.9-no-quota.patch
	epatch "${FILESDIR}"/${P}-fix-build-cflags.patch #516854
}

multilib_src_configure() {
	# we use blkid/uuid from util-linux now
	ac_cv_lib_uuid_uuid_generate=yes \
	ac_cv_lib_blkid_blkid_get_cache=yes \
	ac_cv_path_LDCONFIG=: \
	ECONF_SOURCE="${S}" \
	CC="$(tc-getCC)" \
	BUILD_CC="$(tc-getBUILD_CC)" \
	BUILD_LD="$(tc-getBUILD_LD)" \
	econf \
		--disable-lib{blkid,uuid} \
		--disable-quota \
		$(tc-is-static-only || echo --enable-elf-shlibs) \
		$(tc-has-tls || echo --disable-tls) \
		$(use_enable nls)
}

multilib_src_compile() {
	emake V=1
}

multilib_src_install() {
	emake V=1 STRIP=: DESTDIR="${D}" install || die
	multilib_is_native_abi && gen_usr_ldscript -a com_err ss
	# configure doesn't have an option to disable static libs :/
	use static-libs || find "${ED}" -name '*.a' -delete
}
