# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils libtool multilib toolchain-funcs

DESCRIPTION="BSD tar command"
HOMEPAGE="http://www.libarchive.org/"
SRC_URI="http://www.libarchive.org/downloads/${P}.tar.gz"

LICENSE="BSD BSD-2 BSD-4 public-domain"
SLOT="0/13"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="acl +bzip2 +e2fsprogs expat +iconv kernel_linux libressl +lzma lzo nettle static-libs xattr +zlib"

RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	acl? ( virtual/acl )
	bzip2? ( app-arch/bzip2 )
	expat? ( dev-libs/expat )
	!expat? ( dev-libs/libxml2 )
	iconv? ( virtual/libiconv )
	kernel_linux? (
		xattr? ( sys-apps/attr )
		)
	lzma? ( app-arch/xz-utils )
	lzo? ( >=dev-libs/lzo-2 )
	nettle? ( dev-libs/nettle )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	kernel_linux? (
		virtual/os-headers
		e2fsprogs? ( sys-fs/e2fsprogs )
		)"

DOCS="NEWS README"

src_prepare() {
	epatch "${FILESDIR}"/${P}-CVE-2013-0211.patch
	elibtoolize
}

src_configure() {
	export ac_cv_header_ext2fs_ext2_fs_h=$(usex e2fsprogs) #354923

	# We disable lzmadec because we support the newer liblzma from xz-utils
	# and not liblzmadec with this version.
	econf \
		$(use_enable static-libs static) \
		--enable-bsdtar=$(tc-is-static-only && echo static || echo shared) \
		--enable-bsdcpio=$(tc-is-static-only && echo static || echo shared) \
		$(use_enable xattr) \
		$(use_enable acl) \
		$(use_with zlib) \
		$(use_with bzip2 bz2lib) \
		--without-lzmadec \
		$(use_with iconv) \
		$(use_with lzma) \
		$(use_with lzo lzo2) \
		$(use_with nettle) \
		$(use_with !expat xml2) \
		$(use_with expat)
}

src_test() {
	# Replace the default src_test so that it builds tests in parallel
	emake check
}

src_install() {
	default

	# Libs.private: should be used from libarchive.pc instead
	prune_libtool_files

	# Create tar symlink for FreeBSD
	if ! use prefix && [[ ${CHOST} == *-freebsd* ]]; then
		dosym bsdtar /usr/bin/tar
		echo '.so bsdtar.1' > "${T}"/tar.1
		doman "${T}"/tar.1
		# We may wish to switch to symlink bsdcpio to cpio too one day
	fi
}

pkg_preinst() {
	preserve_old_lib /usr/$(get_libdir)/${PN}$(get_libname 12)
}

pkg_postinst() {
	preserve_old_lib_notify /usr/$(get_libdir)/${PN}$(get_libname 12)
}
