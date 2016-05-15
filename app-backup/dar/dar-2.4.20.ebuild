# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit flag-o-matic

DESCRIPTION="A full featured backup tool, aimed for disks (floppy,CDR(W),DVDR(W),zip,jazz etc.)"
HOMEPAGE="http://dar.linux.free.fr/"
SRC_URI="mirror://sourceforge/dar/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc ~x86 ~amd64-linux"
IUSE="acl dar32 dar64 doc gcrypt lzo nls static static-libs"

RESTRICT="test" # need to be run as root

RDEPEND=">=sys-libs/zlib-1.2.3:=
	!static? ( app-arch/bzip2:= )
	acl? ( !static? ( sys-apps/attr:= ) )
	gcrypt? ( dev-libs/libgcrypt:0= )
	lzo? ( !static? ( dev-libs/lzo:= ) )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	static? ( app-arch/bzip2[static-libs] )
	static? ( sys-libs/zlib[static-libs] )
	acl? ( static? ( sys-apps/attr[static-libs] ) )
	lzo? ( static? ( dev-libs/lzo[static-libs] ) )
	nls? ( sys-devel/gettext )
	doc? ( app-doc/doxygen )"

REQUIRED_USE="?? ( dar32 dar64 )"

DOCS="AUTHORS ChangeLog NEWS README THANKS TODO"

src_configure() {
	local myconf="--disable-upx"

	# Bug 103741
	filter-flags -fomit-frame-pointer

	use acl || myconf="${myconf} --disable-ea-support"
	use dar32 && myconf="${myconf} --enable-mode=32"
	use dar64 && myconf="${myconf} --enable-mode=64"
	use doc || myconf="${myconf} --disable-build-html"
	# use examples && myconf="${myconf} --enable-examples"
	use gcrypt || myconf="${myconf} --disable-libgcrypt-linking"
	use lzo || myconf="${myconf} --disable-liblzo2-linking"
	use nls || myconf="${myconf} --disable-nls"
	if ! use static ; then
		myconf="${myconf} --disable-dar-static"
		if ! use static-libs ; then
			myconf="${myconf} --disable-static"
		fi
	fi

	econf ${myconf}
}

src_install() {
	emake DESTDIR="${D}" pkgdatadir="${EPREFIX}"/usr/share/doc/${PF}/html install

	einstalldocs

	if ! use static-libs ; then
		prune_libtool_files --all
	fi
}
