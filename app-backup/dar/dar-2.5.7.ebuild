# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit confutils flag-o-matic

DESCRIPTION="A full featured backup tool, aimed for disks (floppy,CDR(W),DVDR(W),zip,jazz etc.)"
HOMEPAGE="http://dar.linux.free.fr/"
SRC_URI="mirror://sourceforge/dar/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux"
IUSE="dar32 dar64 doc gcrypt gpg lzo nls static static-libs xattr"

RESTRICT="test" # need to be run as root

RDEPEND=">=sys-libs/zlib-1.2.3:=
	!static? (
		app-arch/bzip2:=
		app-arch/xz-utils:=
		sys-libs/libcap
		gcrypt? ( dev-libs/libgcrypt:0= )
		gpg? ( app-crypt/gpgme )
		xattr? ( sys-apps/attr:= )
	)
	lzo? ( !static? ( dev-libs/lzo:= ) )
	nls? ( virtual/libintl )"

DEPEND="${RDEPEND}
	static? (
		app-arch/bzip2[static-libs]
		app-arch/xz-utils[static-libs]
		sys-libs/libcap[static-libs]
		sys-libs/zlib[static-libs]
		gcrypt? ( dev-libs/libgcrypt:0=[static-libs] )
		gpg? (
			app-crypt/gpgme[static-libs]
			dev-libs/libassuan[static-libs]
			dev-libs/libgpg-error[static-libs]
		)
		lzo? ( dev-libs/lzo[static-libs] )
		xattr? ( sys-apps/attr[static-libs] )
	)
	nls? ( sys-devel/gettext )
	doc? ( app-doc/doxygen )"

REQUIRED_USE="?? ( dar32 dar64 )
		gpg? ( gcrypt )"

DOCS="AUTHORS ChangeLog NEWS README THANKS TODO"

#PATCHES=(
#)

src_configure() {
	local myconf=( --disable-upx )

	# Bug 103741
	filter-flags -fomit-frame-pointer

	# configure.ac is totally funked up regarding the AC_ARG_ENABLE
	# logic.
	# For example "--enable-dar-static" causes configure to DISABLE
	# static builds of dar.
	# Do _not_ use $(use_enable) until you have verified that the
	# logic has been fixed by upstream.
	use xattr || myconf+=( --disable-ea-support )
	use dar32 && myconf+=( --enable-mode=32 )
	use dar64 && myconf+=( --enable-mode=64 )
	use doc || myconf+=( --disable-build-html )
	# use examples && myconf+=( --enable-examples )
	use gcrypt || myconf+=( --disable-libgcrypt-linking )
	use gpg || myconf+=( --disable-gpgme-linking )
	use lzo || myconf+=( --disable-liblzo2-linking )
	use nls || myconf+=( --disable-nls )
	if ! use static ; then
		myconf+=( --disable-dar-static )
		if ! use static-libs ; then
			myconf+=( --disable-static )
		fi
	fi

	econf ${myconf[@]}
}

src_install() {
	emake DESTDIR="${D}" pkgdatadir="${EPREFIX}"/usr/share/doc/${PF}/html install

	einstalldocs

	if ! use static-libs ; then
		prune_libtool_files --all
	fi
}
